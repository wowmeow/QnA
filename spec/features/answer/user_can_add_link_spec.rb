feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do

  given(:user) { create :user }
  given!(:question) { create(:question) }
  # given(:gist_url) { create 'https://en.wikipedia.org/wiki/%22Hello,_World!%22_program' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: 'https://en.wikipedia.org/wiki/%22Hello,_World!%22_program'

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: 'https://en.wikipedia.org/wiki/%22Hello,_World!%22_program'
    end
  end

end