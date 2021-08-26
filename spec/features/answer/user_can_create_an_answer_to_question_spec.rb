feature 'User can create an answer to question', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question on question page
" do
  given(:question) { create(:question) }

  describe 'Authenticated user creates the answer', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'when data is valid' do
      fill_in 'Your answer', with: 'Answer text'
      click_on 'Create'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content('Answer text')
      end
    end

    scenario 'when data is not valid' do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'with attached file' do
      fill_in 'Your answer', with: 'Answer text'
      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

      click_on 'Create'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content('Answer text')
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
