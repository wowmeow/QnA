class AnswersController < ApplicationController
  expose :question
  expose(:answers) { question.answers }
  expose :answer

  def create
    @answer = answers.new(answer_params)

    if @answer.save
      redirect_to question_answers_path
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end

end
