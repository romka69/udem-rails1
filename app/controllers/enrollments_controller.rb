class EnrollmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  before_action :set_enrollment, only: %i[show edit update destroy certificate]
  before_action :set_course, only: %i[new create]

  def index
    # @enrollments = Enrollment.all
    # @pagy, @enrollments = pagy(Enrollment.all)

    @ransack_path = enrollments_path
    @q = Enrollment.ransack(params[:q])
    @q.sorts = ['created_at desc']

    @pagy, @enrollments = pagy(@q.result.includes(:user))

    authorize @enrollments
  end

  def show
  end

  def new
    @enrollment = Enrollment.new
  end

  def edit
    authorize @enrollment
  end

  def create
    if @course.price > 0
      customer = Stripe::Customer.create(
          email: params[:stripeEmail],
          source: params[:stripeToken]
      )
      charge = Stripe::Charge.create(
          customer: customer.id,
          amount: (@course.price * 100).to_i, # * 100 for cents
          description: "@course.title",
          currency: "usd"
      )
    end

    @enrollment = current_user.buy_course(@course)
    redirect_to course_path(@course), notice: "You are enrolled."

    EnrollmentMailer.new_enrollment_student(@enrollment).deliver_now
    EnrollmentMailer.new_enrollment_teacher(@enrollment).deliver_now

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_course_enrollment_path(@course, @enrollment)
  end

  def update
    authorize @enrollment

    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: 'Enrollment was successfully updated.' }
        format.json { render :certificate, status: :ok, location: @enrollment }
      else
        format.html { render :edit }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @enrollment

    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_students
    @ransack_path = my_students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: { user: current_user }).ransack(params[:q])

    @pagy, @enrollments = pagy(@q.result.includes(:user))
    render "index"
  end

  def certificate
    authorize @enrollment, :certificate?

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",
               page_size: "A4",
               template: "enrollments/certificate.pdf.haml"
      end
    end
  end

  private

    def set_enrollment
      @enrollment = Enrollment.friendly.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    def enrollment_params
      params.require(:enrollment).permit(:rating, :review)
    end
end
