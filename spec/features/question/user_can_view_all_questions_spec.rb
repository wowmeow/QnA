feature 'User can view the list of questions', "
  In order to find a suitable question
  As an user
  I'd like to be able to view the list of questions
" do
  given!(:questions) { create_list(:question, 3) }
  given(:user) { create(:user) }

  scenario 'Authenticated user views the list of questions' do
    sign_in(user)

    visit questions_url

    expect(page).to have_text('Question title').exactly(3).times
    expect(page).to have_text('Question text').exactly(3).times
  end

  scenario 'Unauthenticated user views the list of questions' do
    visit questions_url

    expect(page).to have_text('Question title').exactly(3).times
    expect(page).to have_text('Question text').exactly(3).times
  end
end
