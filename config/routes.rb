Rails.application.routes.draw do
  devise_for :users

  mount ActionCable.server => '/cable'

  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_for
      patch :vote_against
      delete :undo_vote
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true, only: %i[create destroy update] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: :create

end
