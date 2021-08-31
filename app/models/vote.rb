class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, presence: true
  validates :user, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: { in: [-1, 1] }
  validates :votable_type, inclusion: { in: %w[Question Answer] }
end
