RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it 'saves a new question in the database' do
        expect { post_create }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post_create
        expect(response).to redirect_to assigns(:question)
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
    let(:patch_update) { patch :update, params: { id: question, question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { { title: 'new title', body: 'new body' } }

      before { patch_update }

      it 'changes question attributes' do
        # question.reload

        expect(question.reload.title).to eq 'new title'
        # expect { patch_update }.to change { question.reload.title }.from('MyString').to('new title')
        expect(question.reload.body).to eq 'new body'
        # expect { patch_update }.to change { question.body.reload }.from(:body).to('new body')
      end

      it 'redirects to updated question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:question, :invalid) }

      before { patch_update }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let(:delete_destroy) { delete :destroy, params: { id: question } }

    it 'deletes the question' do
      expect { delete_destroy }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete_destroy
      expect(response).to redirect_to questions_path
    end
  end

end