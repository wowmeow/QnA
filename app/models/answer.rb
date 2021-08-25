class Answer < ApplicationRecord
  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def make_best!
    transaction do
      question.answers.update_all(best: false)

      update!(best: true)
    end
  end

end
