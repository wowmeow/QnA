feature 'User can create an answer', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question
" do

  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer', js: true do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer text'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer successfully created.'
      within '.answers' do
        expect(page).to have_content 'Answer title'
        expect(page).to have_content 'Answer text'
      end
    end

    scenario 'creates answer with errors', js: true do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank."
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end