feature 'User can delete his answers to the question', "
  In order to remove the answers
  As an authenticated user
  I'd like to be able to delete my answers
", js: true do

  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'deletes his own answers' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to have_content 'Your answers successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete not his own answers' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answers'
    end
  end

  scenario 'Unauthenticated user tries to delete an answers' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Delete answers'
  end
end
