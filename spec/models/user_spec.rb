RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards).dependent(:destroy) }

  describe '#author_of?' do
    subject(:user) { create(:user) }

    context 'when user is the author' do
      let(:question) { create(:question, user: user) }

      it { is_expected.to be_author_of(question) }
    end

    context 'when user is not the author' do
      let(:question) { create(:question) }

      it { is_expected.to_not be_author_of(question) }
    end
  end
end
