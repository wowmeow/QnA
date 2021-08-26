RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:answer) { create(:answer, :with_file) }

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: answer }, format: :js }

    context 'when the user is the author of the answer' do
      before { login(answer.user) }

      it 'deletes the attachment' do
        expect { delete_destroy }.to change(answer.files, :count).by(-1)
      end

      it 'renders the delete view' do
        delete_destroy

        expect(response).to render_template :delete
      end
    end

    context 'when the user is not the author of the answer' do
      before { login(user) }

      it 'does not delete the answer and responses :forbidden' do
        expect { delete_destroy }.not_to change(answer.files, :count)
      end
    end

    context 'when the user is the guest' do
      it 'does not delete the answer' do
        expect { delete_destroy }.not_to change(answer.files, :count)
      end

      it 'responses :unauthorized' do
        delete_destroy

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end