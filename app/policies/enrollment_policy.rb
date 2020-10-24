class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin)
  end

  def edit?
    @user.has_role?(:admin) || @record.course.is_bought?(@user)
  end

  def update?
    @user.has_role?(:admin) || @record.course.is_bought?(@user)
  end

  def destroy?
    @user.has_role?(:admin)
  end
end
