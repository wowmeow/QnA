feature 'User can view the question with answers', "
  In order to get answers to the question
  Any user
  I'd like to be able to view the question with answers
" do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Any user views the question with answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end