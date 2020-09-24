class ApplicationController < ActionController::Base
  include PublicActivity::StoreController # save current_user using this gem

  before_action :authenticate_user!
  before_action :set_global_variables, if: :user_signed_in?

  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
  end
end
