feature 'The user can select the best answer for his question', "
  In order to choose more appropriate answer
  As an authenticated user
  I would like to be able to mark the only one question as the best
", js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answers) { create_list(:answer, 4, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(question.user)
      visit question_path(answer.question)
    end

    # scenario 'when he sets the best answer' do
    #   within "#answer-#{answer.id}" do
    #     expect(page).not_to have_content 'The best answer:'
    #
    #     click_on 'Best'
    #
    #     expect(page).to have_content 'The best answer:'
    #   end
    # end

    # scenario 'when he sets a new answer as best' do
    #   within "div#answer_#{answers[-1].id}" do
    #     click_on 'Best'
    #   end
    #
    #   within "div#answer_#{answers[0].id}" do
    #     click_on 'Best'
    #
    #     expect(page).to_not have_content 'Best'
    #     expect(page).to have_content 'The best answer:'
    #   end
    # end

    scenario 'when mark the answer as best with reward' do
      create(:reward, question: question)

      within "#answer-#{answer.id}" do
        click_on('Best')

        expect(page).to have_content 'The best answer:'
        expect(page).to have_content 'Reward:'
        expect(page).to_not have_link 'Best'
      end
    end
  end

  scenario 'The authenticated user tries to set the best answer of for the question of the other user' do
    sign_in user
    visit question_path(answer.question)

    expect(page).to_not have_link 'Best'
  end

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Best'
  end
end


