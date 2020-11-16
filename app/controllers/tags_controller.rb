class TagsController < ApplicationController
  def index
    @tags = Tag.all.order(course_tags_count: :desc)

    authorize @tags
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag
    else
      render json: { errors: @tag.errors.full_messages }
    end
  end

  def destroy
    @tag = Tag.find(params[:id])

    authorize @tag

    if @tag.destroy
      redirect_to tags_path, notice: "Tag deleted."
    else
      redirect_to tags_path, alert: "Tag not deleted."
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
