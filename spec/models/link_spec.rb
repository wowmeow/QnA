RSpec.describe Link, type: :model do
  it { should belong_to :question }
  # it { should belong_to :answer }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }


end
