class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    @user.has_role?(:admin) || @record.lesson.course.user == @user || @record.lesson.course.is_bought?(@user)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user || @record.lesson.course.user == @user
  end
end
