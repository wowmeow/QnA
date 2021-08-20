feature 'User can edit his answers', "
  In order to correct mistakes
  As an author of answers
  I'd like ot be able to edit my answers
", js: true do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answers' do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Title', with: 'Edited answers'
        fill_in 'Body', with: 'Text'
        click_on 'Save'

        expect(page).to_not have_content answer.title
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answers'
        expect(page).to have_content 'Text'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answers with errors'
    scenario "tries to edit other user's question"
  end
end
