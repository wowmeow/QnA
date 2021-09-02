# feature 'User can edit his question', "
#   In order to put some updates or correct mistakes
#   As an author of the question
#   I would like to be able to edit my question
# ", js: true do
#
#   given!(:question) { create(:question, links: [link]) }
#   given(:link) { create(:link) }
#
#   describe 'Authenticated user (author)' do
#
#     background do
#       sign_in(question.user)
#       visit questions_path
#
#       click_on 'Edit'
#     end
#
#     scenario 'edits his question' do
#       find("#question_body-#{question.id}").fill_in(with: 'Edited question')
#       click_on 'Save'
#
#       visit questions_path
#       expect(page).to_not have_selector 'textarea'
#
#       visit question_path(question)
#       expect(page).to_not have_content question.body
#       expect(page).to have_content 'Edited question'
#     end
#
#     scenario 'when editing attaches files to the question' do
#       attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
#       click_on 'Save'
#
#       visit question_path(question)
#
#       expect(page).to have_link 'rails_helper.rb'
#       expect(page).to have_link 'spec_helper.rb'
#     end
#
#     scenario 'edits his question with errors' do
#       find("#question_body-#{question.id}").fill_in(with: '')
#       click_on 'Save'
#
#       expect(page).to have_content question.body
#       expect(page).to have_content "Body can't be blank"
#     end
#   end
#
#   describe 'Authenticated user (not author)' do
#     given!(:user) { create(:user) }
#
#     scenario "tries to edit other user's question" do
#       sign_in(user)
#       visit questions_url
#
#       expect(page).to_not have_link 'Edit'
#     end
#   end
#
#   scenario 'Unauthenticated can not edit question' do
#     visit questions_url
#
#     expect(page).to_not have_link 'Edit'
#   end
# end
