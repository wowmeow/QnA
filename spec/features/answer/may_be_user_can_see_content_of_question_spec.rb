feature 'User can view answers on the question page', "
  In order to get answers to the question
  As an user
  I'd like to be able to view answers on the question page
" do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user views answers on the question page' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_text('Answer title').exactly(3).times
    expect(page).to have_text('Answer text').exactly(3).times
  end

  scenario 'Unauthenticated user views the question with answers' do
    visit question_path(question)

    expect(page).to have_text('Answer title').exactly(3).times
    expect(page).to have_text('Answer text').exactly(3).times
  end
end