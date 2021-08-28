feature 'User can edit their answer of question', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
", js: true do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link) { create(:link, linkable: question) }
  given!(:answer) { create(:answer, question: question, user: user, links: [link]) }

  describe 'Authenticated user' do
    given!(:other_user) { create(:user) }

    scenario 'edits his answer' do
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

    scenario 'edits his answer with errors' do
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

    scenario 'when editing attaches files to the answer' do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'when delete link from the answer' do
      sign_in user
      visit questions_path

      click_on 'Edit'

      expect(page).to have_link link.name, href: link.url

      within '.answers' do
        click_on 'Delete link'
        click_on 'Save'

        expect(page).to_not have_link link.name, href: link.url
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

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
