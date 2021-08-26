feature 'User can delete files from his question', '
  In order to avoid unnecessary files
  As the authenticated author of the question
  I would like to be able to delete files from his question
', js: true do

  given!(:question_with_file) { create(:question, :with_file) }
  given(:filename) { question_with_file.files[0].filename.to_s }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes the attached files from the question' do
      sign_in(question_with_file.user)
      visit question_path(question_with_file)

      expect(page).to have_link filename

      within('.attachments') { click_on 'Delete file' }
      expect(page).to_not have_link filename
    end

    scenario 'tries to delete the attached files from the question' do
      sign_in(user)
      visit question_path(question_with_file)

      expect(page).to have_link filename
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Unauthenticated user tries to delete the attached files from the question' do
    visit question_path(question_with_file)

    expect(page).to have_link filename
    expect(page).to_not have_link 'Delete file'
  end
end