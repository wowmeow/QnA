class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :question, only: :create

  expose :question, -> { Question.find(params[:question_id]) if params[:question_id] }
  expose :answer

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
      flash.now[:notice] = 'Answer was successfully deleted'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
