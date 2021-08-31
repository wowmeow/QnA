feature 'User can vote for the answer', "
  As an authenticated user
  I'd like to be able to vote for a answer I like
", js: true do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'votes for the answer' do
      within ".answers" do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against the answer' do
      within ".answers" do
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'cancels his like-vote and votes for the question' do
      within ".answers" do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end

        click_on 'Undo'

        within '.rating' do
          expect(page).to have_content '0'
        end

        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'cancels his dislike-vote and votes for the answer' do
      within ".answers" do
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content '-1'
        end

        click_on 'Undo'

        within '.rating' do
          expect(page).to have_content '0'
        end

        click_on 'Like'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end
  end

  scenario 'Unauthenticated user try to vote' do
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
      expect(page).to_not have_link 'Undo'
      expect(page).to_not have_selector '.vote'
    end
  end
end