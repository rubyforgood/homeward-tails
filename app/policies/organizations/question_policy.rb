# frozen_string_literal: true

class Organizations::QuestionPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  alias_rule :new?, :create?, :index?, to: :manage?

  def manage?
    permission?(:manage_questions)
  end
end
