class Organizations::PersonPolicy < ApplicationPolicy
  def index?
    permission?(:view_people)
  end

  def show?
    permission?(:view_people)
  end

  def edit?
    permission?(:view_people)
  end

  def update?
    permission?(:view_people)
  end
end
