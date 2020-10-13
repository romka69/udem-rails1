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
    @activities = PublicActivity::Activity.all
  end
end
