RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it {should allow_value('google.com').for(:url)}
  it {should_not allow_value('google').for(:url)}

  describe '#is_gist?' do
    let(:question) { create(:question) }
    let(:gist) { create(:link, url: 'https://gist.github.com/example') }

    context 'when return true' do
      it { expect(gist).to be_is_gist }
    end

    context 'when return false' do
      it { expect(create(:link)).to_not be_is_gist }
    end
  end
end
