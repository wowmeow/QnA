feature 'User can view the question with answers', "
  In order to get answers to the question
  As an user
  I'd like to be able to view the question with answers
" do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user views the question with answers' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Unauthenticated user views the question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end