feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do

  given(:user) { create :user }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: 'https://en.wikipedia.org/wiki/%22Hello,_World!%22_program'

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: 'https://en.wikipedia.org/wiki/%22Hello,_World!%22_program'
  end

end