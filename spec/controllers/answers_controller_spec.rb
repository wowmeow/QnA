RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }

      context 'with valid attributes' do
        let!(:answer_params) { attributes_for(:answer) }

        it 'saves a new answer in the database' do
          expect { post_create }.to change(question.answers, :count).by(1)
        end

        it 'belongs to the user' do
          post_create
          expect(assigns(:exposed_answer).user_id).to eq(user.id)
        end

        it 'redirect to question show view' do
          post_create
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save the answer' do
          expect { post_create }.to_not change(question.answers, :count)
        end

        it 're-renders new view' do
          post_create
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: question, user: author) }
    let(:delete_destroy) { delete :destroy, params: { question_id: question, id: answer } }

    before { login(author) }

    context 'author' do
      it 'deletes the answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to question
      end
    end

    context 'not author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not delete the question' do
        expect { delete_destroy }.to_not change(Answer, :count)
      end

      it 'redirects to question show' do
        delete_destroy
        expect(response).to redirect_to question
      end
    end
  end
end