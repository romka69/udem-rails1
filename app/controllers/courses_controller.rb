class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  before_action :set_course, only: %i[show edit update destroy approve unapprove analytics]

  def index
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    @ransack_courses.sorts = ['created_at desc']
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def show
    authorize @course

    @lessons = @course.lessons.rank(:row_order)
    @enrollments_with_reviews = @course.enrollments.reviewed
    @another_courses = Course.all.where.not(id: @course.id)
  end

  def new
    @course = Course.new
    @tags = Tag.all

    authorize @course
  end

  def edit
    authorize @course

    @tags = Tag.all
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user

    authorize @course

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      @tags = Tag.all
      render :new
    end
  end

  def update
    authorize @course

    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      @tags = Tag.all
      render :edit
    end
  end

  def destroy
    authorize @course

    if @course.destroy
      redirect_to courses_url, notice: 'Course was successfully destroyed.'
    else
      redirect_to @course, alert: "Course has enrollments. Can't destroy."
    end
  end

  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: { user: current_user })
                             .ransack(params[:courses_search], search_key: :courses_search)
    @ransack_courses.sorts = ['created_at desc']
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render "index"
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments)
                             .merge(Enrollment.pending_review.where(user: current_user))
                             .ransack(params[:courses_search], search_key: :courses_search)
    @ransack_courses.sorts = ['created_at desc']
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render "index"
  end

  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user)
                             .ransack(params[:courses_search], search_key: :courses_search)
    @ransack_courses.sorts = ['created_at desc']
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render "index"
  end

  def approve
    authorize @course, :approve?

    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course approved and visible."
  end

  def unapprove
    authorize @course, :approve?

    @course.update_attribute(:approved, false)
    redirect_to @course, notice: "Course unapproved and hidden."
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved
                           .ransack(params[:courses_search], search_key: :courses_search)
    @ransack_courses.sorts = ['created_at asc']
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, course_tags: :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)

    render "index"
  end

  def analytics
    authorize @course, :owner?
  end

  private

    def set_course
      @course = Course.friendly.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :short_description, :price,
                                     :level, :language, :published, :logo, tag_ids: [],
                                     lessons_attributes: %i[id title content video _destroy])
    end
end
