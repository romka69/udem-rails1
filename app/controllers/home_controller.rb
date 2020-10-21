class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user})
                             .order(created_at: :desc).limit(3)
    @top_rated_courses = Course.top_rated
    @popular_courses = Course.popular
    @latest_courses = Course.latest
    @latest_reviews = Enrollment.reviewed.latest_reviews
  end

  def activity
    if current_user.has_role?(:admin)
      @activities = PublicActivity::Activity.all
    else
      redirect_to root_path, alert: "No access."
    end
  end

  def analytics
    if current_user.has_role?(:admin)
      @users = User.all
      @enrollments = Enrollment.all
      @courses = Course.all
    else
      redirect_to root_path, alert: "No access."
    end
  end
end
