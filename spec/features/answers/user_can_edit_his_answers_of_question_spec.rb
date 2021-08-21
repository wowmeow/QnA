feature 'User can edit their answers of question', "
  In order to correct mistakes
  As an author of answers
  I'd like ot be able to edit my answers
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'edits his answers', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: 'Edited answer')
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answers with errors'
    scenario "tries to edit other user's question"
  end

  scenario 'Unauthenticated can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
