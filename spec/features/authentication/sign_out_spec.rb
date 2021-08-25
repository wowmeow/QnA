feature 'User can sign out', "
  In order to end the session
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'Registered user can sign out' do
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
