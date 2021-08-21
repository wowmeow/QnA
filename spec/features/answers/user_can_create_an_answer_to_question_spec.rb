feature 'User can create an answer to question', "
  In order to answers the question
  As an authenticated user
  I'd like to be able to answers the question on question page
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
  end

  scenario 'Unauthenticated user tries to answers the question' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
