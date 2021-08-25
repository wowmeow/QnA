class Answer < ApplicationRecord
  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_true_in_column_best!
    transaction do
      Answer.where(question_id: question_id).update_all(best: false)

      update!(best: true)
    end
  end

end
