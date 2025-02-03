class Organizations::PetPolicy < Organizations::ApplicationPolicy
  pre_check :verify_organization!
  pre_check :verify_active_staff!

  alias_rule :index?, :create?, :new?, :attach_files?, :attach_images?,
    to: :manage?

  def manage?
    permission?(:manage_pets)
  end
end
