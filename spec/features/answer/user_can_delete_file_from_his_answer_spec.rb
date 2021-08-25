feature 'User can delete files from his answer', '
  In order to avoid unnecessary files
  As the authenticated author of the answer
  I would like to be able to delete files from his answer
', js: true do

  given!(:answer_with_file) { create(:answer, :with_file) }
  given(:filename) { answer_with_file.files[0].filename.to_s }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes the attached files from the answer' do
      sign_in(answer_with_file.user)
      visit question_path(answer_with_file.question)

      expect(page).to have_link filename

      within('.attachments') { click_on 'Delete file' }
      expect(page).to_not have_link filename
    end

    scenario 'tries to delete the attached files from the answer' do
      sign_in(user)
      visit question_path(answer_with_file.question)

      expect(page).to have_link filename
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Unauthenticated user tries to delete the attached files from the answer' do
    visit question_path(answer_with_file.question)

    expect(page).to have_link filename
    expect(page).to_not have_link 'Delete file'
  end
end