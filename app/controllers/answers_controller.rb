class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[new create]

  expose :question
  expose(:answers) { question.answers }
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user = current_user

    if answer.save
      redirect_to question_path(question)
    else
      render :new
    end
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end 