class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  expose(:questions) { Question.all }
  expose :question, find: -> { Question.with_attached_files.find(params[:id]) }

  def new
    question.links.build
    question.reward = Reward.new
  end

  def show
    @exposed_answer = Answer.new
    @exposed_answer.links.build
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
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: [:id, :title, :image, :_destroy])
  end
end
