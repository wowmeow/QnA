module Votable
  extend ActiveSupport::Concern

  included { has_many :votes, as: :votable, dependent: :destroy }

  def rating
    votes.sum(:value)
  end

  def undo(user)
    find_vote_of(user)&.destroy!
  end

  private

  def find_vote_of(user)
    votes.find_by(user: user)
  end
end