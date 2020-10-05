class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    @user.has_role?(:teacher) || @record.course.user == @user
  end

  def create?
    @record.course.user == @user
  end

  def show?
    @user.has_role?(:admin) || @record.course.user == @user || @record.course.bought(@user) == false
  end

  def edit?
    @user.has_role?(:admin) || @record.course.user == @user
  end

  def update?
    @user.has_role?(:admin) || @record.course.user == @user
  end

  def destroy?
    @user.has_role?(:admin) || @record.course.user == @user
  end
end
