class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]
  before_action :question, only: :create

  expose :question, -> { Question.find(params[:question_id]) if params[:question_id] }
  expose :answer, find: -> { Answer.with_attached_files.find(params[:id]) }

  def create
    @exposed_answer = question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      @question = answer.question
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      @question = answer.question
    end
  end

  def best
    answer.make_best! if current_user.author_of?(answer.question)
    @question = answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best, files: [], links_attributes: %i[id name url _destroy])
  end
end
