class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :question, only: %i[new create]

  expose :question
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user = current_user

    if answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to question_path(question)
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:notice] = "You can't delete the answer created by another person"
    end

    redirect_to question_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end 