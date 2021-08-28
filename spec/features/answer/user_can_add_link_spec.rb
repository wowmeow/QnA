feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
", js: true do

  given!(:answer) { create :answer }

  describe 'Authenticated user adds a link' do

  background do
    sign_in(answer.user)
    visit question_path(answer.question)
  end

  scenario 'adds a link when create an answer' do
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'Google'
    fill_in 'URL', with: 'https://www.google.com'

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'URL', with: 'https://www.yandex.ru'
    end

    click_on 'Create'

    expect(page).to have_link 'Google', href: 'https://www.google.com'
    expect(page).to have_link 'Yandex', href: 'https://www.yandex.ru'

  end

  scenario 'adds a link when edit an answer' do
    click_on 'Edit'

    within '.answers' do
      click_on 'Add link'

      fill_in 'Link name', with: 'Google'
      fill_in 'URL', with: 'https://www.google.com'

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'URL', with: 'https://www.yandex.ru'
      end

      click_on 'Save'

      expect(page).to have_link 'Google', href: 'https://www.google.com'
      expect(page).to have_link 'Yandex', href: 'https://www.yandex.ru'
    end
  end

  scenario 'try to add invalid link when edit an answer' do
    click_on 'Edit'

    within '.answers' do
      click_on 'Add link'

      fill_in 'Link name', with: 'Link'
      fill_in 'URL', with: 'google'

      click_on 'Save'
    end

    expect(page).to have_content 'Links url is an invalid URL'
    expect(page).to_not have_link 'Link', href: 'google'
  end
end

end