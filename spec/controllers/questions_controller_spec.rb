RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #show' do
    before { get :show, params: { id: question }, format: :js }

    it 'assigns new answer for question' do
      expect(assigns(:exposed_answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    let(:post_create) { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let!(:question_params) { attributes_for(:question) }

      it 'saves a new question in the database' do
        expect { post_create }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post_create

        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:question, :invalid) }

      it 'does not save the question' do
        expect { post_create }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: { id: question, question: question_params }, format: :js }

    before { sign_in(question.user) }

    context 'with valid attributes' do
      let(:question_params) { { title: 'new title', body: 'new body' } }
      before { patch_update }

      it 'changes question attributes' do
        expect(question.reload).to have_attributes(title: 'new title', body: 'new body')
      end

      it 'renders the update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:question, :invalid) }

      before { patch_update }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'Question title'
        expect(question.body).to eq 'Question text'
      end

      it 'renders the update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let(:delete_destroy) { delete :destroy, params: { id: question }, format: :js }

    context 'author' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete_destroy
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      before { login(user) }

      it 'does not delete the question' do
        expect { delete_destroy }.to_not change(Question, :count)
      end

      it 'redirects to question show' do
        delete_destroy
        expect(response).to redirect_to question
      end
    end
  end
end
