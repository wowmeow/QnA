RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'true if user is the author of question' do
      expect(author).to be_author_of(question)
    end

    it 'false if user is not the author of question' do
      expect(user).not_to be_author_of(question)
    end
  end
end
