class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose(:questions) { Question.all }
  expose :question

  def show
    @exposed_answer = Answer.new
  end

  def create
    @exposed_question = current_user.questions.new(question_params)

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :file)
  end
end
