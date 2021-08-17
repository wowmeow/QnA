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

    scenario 'answers the question' do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer text'
      click_on 'Save'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer title'
      expect(page).to have_content 'Answer text'
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Save'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end