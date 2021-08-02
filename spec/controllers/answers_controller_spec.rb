RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  
  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in the database' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post_create
        expect(response).to redirect_to assigns(:question_answers)
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save the question' do
        expect { post_create }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post_create
        expect(response).to render_template :new
      end
    end
  end

end