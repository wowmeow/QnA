feature 'User can create an answers', "
  In order to answers the question
  As an authenticated user
  I'd like to be able to answers the question
" do
  given(:question) { create(:question) }

  describe 'Authenticated user creates the answer', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'when data is valid' do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer text'
      click_on 'Create'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        # expect(page).to have_content 'Your answers successfully created.'
        expect(page).to have_content(title: 'Answer title', body: 'Answer text')
      end
    end

    scenario 'when data is not valid' do
      click_on 'Create'

      # expect(page).to have_content "Title can't be blank."
    end
  end

  scenario 'Unauthenticated user tries to answers the question' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
