feature 'User can delete his question', "
  In order to remove the question
  As an authenticated user
  I'd like to be able to delete the question
" do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes his own question' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      click_on 'Delete'

      expect(page).to have_content 'The question successfully deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'tries to delete not his own question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_link 'Delete'
  end
end
