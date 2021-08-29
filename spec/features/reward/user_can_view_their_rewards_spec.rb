feature 'User can view their rewards', "
I'd like to be able to view the list of my rewards
" do
  let(:question) { create(:question) }
  given(:rewards) { create_list(:reward, 3, question: question) }
  given(:user) { create(:user, rewards: rewards)}

  scenario 'User can view all their rewards' do
    sign_in(user)
    visit rewards_path

    user.rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
    end
  end
end