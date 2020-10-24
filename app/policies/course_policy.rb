class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @record.published && @record.approved ||
      @user.present? && @user.has_role?(:admin) ||
      @user.present? && @record.user == @user ||
      @user.present? && @record.is_bought?(@user)
  end

  def new?
    @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def edit?
    # @user.has_role?(:admin) || @record.user == @user
    @record.user == @user
  end

  def update?
    # @user.has_role?(:admin) || @record.user == @user
    @record.user == @user
  end

  def destroy?
    # @user.has_role?(:admin)  || @record.user == @user
    @record.user == @user && @record.enrollments.none?
  end

  def owner?
    @record.user == @user
  end

  def admin_or_owner?
    @user.has_role?(:admin) || @record.user == @user
  end

  def approve?
    @user.has_role?(:admin)
  end
end
