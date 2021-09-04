feature 'User can edit his question', "
  In order to put some updates or correct mistakes
  As an author of the question
  I would like to be able to edit my question
", js: true do

  given!(:question) { create(:question, links: [link]) }
  given(:link) { create(:link) }

  describe 'Authenticated user (author)' do

    background do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edits his question' do
      within '.question' do
        fill_in 'Title', with: 'Edited question'
        click_on 'Save'

        expect(page).to_not have_selector 'textarea'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'Edited question'

      end
    end

    scenario 'when editing attaches files to the question' do
      within '.question' do
        attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
      end
    end
  end

  describe 'Authenticated user (not author)' do
    given!(:user) { create(:user) }

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated can not edit question' do
    expect(page).to_not have_link 'Edit'
  end
end
