class CommentsController < ApplicationController
  before_action :set_course, only: %i[create destroy]
  before_action :set_lesson, only: %i[create destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.lesson = @lesson
    @comment.user = current_user

    if @comment.save
      redirect_to course_lesson_path(@course, @lesson), notice: "Comment added."
    else
      redirect_to course_lesson_path(@course, @lesson), alert: "Comment missing."
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to course_lesson_path(@course, @lesson), notice: "Comment deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_course
    @course = Course.friendly.find(params[:course_id])
  end

  def set_lesson
    @lesson = Lesson.friendly.find(params[:lesson_id])
  end
end
