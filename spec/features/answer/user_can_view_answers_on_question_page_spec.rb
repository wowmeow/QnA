feature 'User can view answer on the question page', "
  In order to get answer to the question
  As an authenticated or unauthenticated user
  I'd like to be able to view answer on the question page
", js: true do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user views answer on the question page' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content('Create new answer')
    expect(page).to have_content('Answer text').exactly(3).times
  end

  scenario 'Unauthenticated user views the question with answer' do
    visit question_path(question)

    expect(page).to have_content('Create new answer')
    expect(page).to have_text('Answer text').exactly(3).times
  end
end
