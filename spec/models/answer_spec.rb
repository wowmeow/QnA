RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it { is_expected.to have_db_column(:best).of_type(:boolean).with_options(null: false, default: false) }

  let(:question) { create(:question) }

  describe '#make_best!' do
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question) }

    it 'sets only one answer to be the best' do
      answer_1.make_best!
      answer_2.make_best!

      expect(question.answers.where(best: true).count).to eq 1
      expect(answer_2).to be_best
    end
  end

  describe '#default_scope(sort by best)' do
    let(:answer_1) { create(:answer, question: question) }
    let(:answer_2) { create(:answer, question: question) }
    let(:best_answer) { create(:answer, best: true, question: question) }

    it 'returns the ordered list of answer by the best one first and created ASC the next ones' do
      expect(question.answers).to eq [best_answer, answer_1, answer_2]
    end
  end
end
