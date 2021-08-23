RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      let(:post_create) { post :create, params: { question_id: question, answer: answer_params }, format: :js }

      context 'with valid attributes' do
        let!(:answer_params) { attributes_for(:answer) }

        it 'saves a new answers in the database' do
          expect { post_create }.to change(question.answers, :count).by(1)
        end

        it 'belongs to the user' do
          post_create
          expect(assigns(:exposed_answer).user_id).to eq(user.id)
        end

        it 'renders create template' do
          post_create
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let!(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save the answers' do
          expect { post_create }.to_not change(question.answers, :count)
        end

        it 'renders create template' do
          post_create
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:patch_update) { patch :update, params: { id: answer, answer: answer_params }, format: :js }

    before { sign_in(answer.user) }

    context 'with valid attributes' do
      let(:answer_params) { { body: 'new body' } }
      before { patch_update }

      it 'changes answers attributes' do
        expect(answer.reload).to have_attributes(body: 'new body')
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not change answer attributes' do
        expect { patch_update }.not_to change { answer.body }
      end

      it 'renders update view' do
        patch_update
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer }
    let(:delete_destroy) { delete :destroy, params: { id: answer }, format: :js }

    context 'when the user is the author' do
      before { login(answer.user) }

      it 'deletes the answers' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end

    context 'when the user is not the author' do
      before { login(user) }

      it 'does not delete the question' do
        expect { delete_destroy }.to_not change(Answer, :count)
      end
    end

    context 'when the user is not authenticated' do
      it 'does not delete the answer' do
        expect { delete_destroy }.not_to change(Answer, :count)
      end

      it 'responses :unauthorized' do
        delete_destroy
        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
