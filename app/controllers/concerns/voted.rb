module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_for, :vote_against, :undo_vote, :user_not_author, :undo]
    before_action :render_errors, only: [:vote_for, :vote_against, :undo_vote]

    # after_action :render_json, only: [:vote_for, :vote_against, :undo_vote]
  end

  def vote_for
    @votable.votes.create!(user: current_user, value: 1)
    render_json
  end

  def vote_against
    @votable.votes.create!(user: current_user, value: -1)
    render_json
  end

  def undo_vote
    @votable.undo(current_user)
    render_json
  end

  private

  def render_json
    render json: { id: @votable.id, type: @votable.class.to_s.downcase, rating: @votable.rating }
  end

  def render_errors
    render json: { message: "You can't vote!" }, status: :unprocessable_entity if current_user&.author_of?(@votable)
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end