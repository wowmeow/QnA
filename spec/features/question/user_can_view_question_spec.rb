feature 'User can view the question', "
  In order to get answers to the question
  As an user
  I'd like to be able to view the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user views the question' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Unauthenticated user views the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
