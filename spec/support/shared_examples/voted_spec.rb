shared_examples "voted" do
  let(:user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:expected_response) { { id: votable.id, type: votable.class.to_s.downcase, rating: votable.rating }.to_json }
  let(:error_response) { { message: "You can't vote!" }.to_json }

  describe 'PATCH #vote_for' do
    let(:patch_vote_for) { patch :vote_for, params: { id: votable, format: :json } }

    context 'for not votable user' do
      before { login(user) }

      it 'saves a new vote' do
        expect { patch_vote_for }.to change(Vote, :count).by(1)
      end

      it 'render valid json' do
        http_request
        expect(response.body).to eq expected_response
      end
      end

    context 'for votable user' do
      before { login(user) }
      before { patch :vote_for, params: { id: votable } }

      it 'not saves a new vote' do
        expect { patch_vote_for }.to_not change(Vote, :count)
      end
    end

    context 'for user-author' do
      before { login(votable.user) }

      it 'not saves a new vote' do
        expect { patch_vote_for }.to_not change(Vote, :count)
      end

      it 'returns the error response' do
        patch_vote_for
        expect(response.body).to eq error_response
      end
    end

    context 'for unauthorized user' do
      it 'not saves a new vote' do
        expect { patch_vote_for }.to_not change(Vote, :count)
      end
    end
  end

  describe 'PATCH #vote_against' do
    let(:patch_vote_against) { patch :vote_against, params: { id: votable, format: :json } }

    context 'for not votable user' do
      before { login(user) }

      it 'saves a new vote' do
        expect { patch_vote_against }.to change(votable, :rating).by(-1)
      end

      it 'render valid json' do
        patch_vote_against
        expect(response.body).to eq expected_response
      end
    end

    context 'for votable user' do
      before { login(user) }
      before { patch :vote_against, params: { id: votable } }

      it 'not saves a new vote' do
        expect { patch_vote_against }.to_not change(Vote, :count)
      end
    end

    context 'for user-author' do
      before { login(votable.user) }

      it 'not saves a new vote' do
        expect { patch_vote_against }.to_not change(Vote, :count)
      end

      it 'returns the error response' do
        patch_vote_against
        expect(response.body).to eq error_response
      end
    end

    context 'for unauthorized user' do
      it 'not saves a new vote' do
        expect { patch_vote_against }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #undo_vote' do
    let(:delete_undo_vote) { delete :undo_vote, params: { id: votable, format: :json } }

    context 'for not votable user' do
      before { login(user) }

      it 'not saves a new vote' do
        expect { delete_undo_vote }.to_not change(Vote, :count)
      end

      it 'render valid json' do
        delete_undo_vote
        expect(response.body).to eq expected_response
      end
    end

    context 'for votable user' do
      before { login(user) }
      before { patch :vote_for, params: { id: votable } }

      it 'nullify vote' do
        expect { delete_undo_vote }.to change(votable, :rating).by(-1)
      end
    end

    context 'for user-author' do
      before { login(votable.user) }

      it 'not saves a new vote' do
        expect { delete_undo_vote }.to_not change(Vote, :count)
      end

      it 'returns the error response' do
        delete_undo_vote
        expect(response.body).to eq error_response
      end
    end

    context 'for unauthorized user' do
      it 'not saves a new vote' do
        expect { delete_undo_vote }.to_not change(Vote, :count)
      end
    end
  end
end