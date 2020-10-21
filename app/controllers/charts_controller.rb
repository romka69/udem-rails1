class ChartsController < ApplicationController
  def users_per_day
    if current_user.has_role?(:admin)
      render json: User.group_by_day(:created_at).count
    end
  end

  def enrollments_per_day
    if current_user.has_role?(:admin)
      render json: Enrollment.group_by_day(:created_at).count
    end
  end

  def course_popularity
    if current_user.has_role?(:admin)
      render json: Enrollment.joins(:course).group(:"courses.title").count
    end
  end
end
