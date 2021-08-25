feature 'User can edit his question', "
  In order to put some updates or correct mistakes
  As an author of the question
  I would like to be able to edit my question
" do

  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given!(:user) { create(:user) }

    scenario 'edits his question' do
      sign_in(question.user)
      visit questions_path

      click_on 'Edit'

      find("#question_body-#{question.id}").fill_in(with: 'Edited question')
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'Edited question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edits his question with errors' do
      sign_in(question.user)
      visit questions_path

      click_on 'Edit'

      find("#question_body-#{question.id}").fill_in(with: '')
      click_on 'Save'

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit questions_url

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated can not edit question' do
    visit questions_url

    expect(page).to_not have_link 'Edit'
  end
end
