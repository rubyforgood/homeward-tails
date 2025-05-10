class Organizations::FaqPolicy < ApplicationPolicy
  pre_check :verify_record_organization!

  alias_rule :new?, :create?, :index?, to: :manage?

  def manage?
    permission?(:manage_faqs)
  end
end
