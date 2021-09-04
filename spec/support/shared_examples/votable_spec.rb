shared_examples_for 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let!(:vote_of_first_user) { create(:vote, user: first_user, votable: votable) }
  let!(:vote_of_second_user) { create(:vote, user: second_user, votable: votable) }

  describe '#rating' do
    it { expect(votable.rating).to eq(2) }
  end

  describe '#undo' do
    before { votable.undo(first_user) }
    it { expect(votable.rating).to eq(1) }
  end
end