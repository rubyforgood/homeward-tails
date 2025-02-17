class Organizations::PetPolicy < ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  alias_rule :index?, :create?, :new?, :attach_files?, :attach_images?,
    to: :manage?

  # TODO: unclear why I needed to add this
  # relation_scope do |relation|
  #  next relation
  # end

  def manage?
    permission?(:manage_pets)
  end
end
