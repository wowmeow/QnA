feature 'User can delete his answer to the question', "
  In order to remove the answer
  As an authenticated user
  I'd like to be able to delete my answer
", js: true do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes his own answer' do
      sign_in(answer.user)
      visit question_path(question)

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete not his own answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Delete answer'
  end
end
