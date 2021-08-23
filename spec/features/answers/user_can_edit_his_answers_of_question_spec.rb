feature 'User can edit their answers of question', "
  In order to correct mistakes
  As an author of answers
  I'd like ot be able to edit my answers
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    given!(:other_user) { create(:user) }

    scenario 'edits his answers' do
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

    scenario 'edits his answers with errors' do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: '')
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(other_user)
      visit question_path(question)

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
