module Authorizable
  extend ActiveSupport::Concern

  def permission?(name)
    permissions.include?(name)
  end

  ADOPTER_PERMISSIONS = %i[
    view_adopter_foster_dashboard
    create_adopter_applications
    view_adopter_applications
    view_adopter_foster_matches
    withdraw_adopter_applications
    purge_avatar
    manage_likes
    view_adopted_pets
    read_pet_tasks
    view_external_form
    view_form_answers
  ].freeze

  FOSTERER_PERMISSIONS = %i[
    view_adopter_foster_dashboard
    view_adopter_foster_matches
    purge_avatar
  ].freeze

  ADMIN_PERMISSIONS = (
    ADOPTER_PERMISSIONS.excluding(
      %i[
        view_adopter_foster_dashboard
        view_adopter_foster_matches
        create_adopter_applications
        manage_likes
      ]
    ) + %i[
      review_adopter_applications
      invite_fosterers
      update_fosterers
      purge_attachments
      manage_default_pet_tasks
      manage_forms
      manage_external_form_uploads
      manage_questions
      manage_matches
      manage_pets
      manage_tasks
      view_organization_dashboard
      view_people
      view_form_submissions
      manage_faqs
      activate_adopter
      activate_foster
      manage_notes
    ]
  ).freeze

  SUPER_ADMIN_PERMISSIONS = (
    ADMIN_PERMISSIONS + %i[
      activate_staff
      invite_staff
      manage_organization
      manage_custom_page
      manage_staff
      change_user_roles
      edit_people_names
    ]
  ).freeze

  PERMISSIONS = {
    adopter: ADOPTER_PERMISSIONS,
    fosterer: FOSTERER_PERMISSIONS,
    admin: ADMIN_PERMISSIONS,
    super_admin: SUPER_ADMIN_PERMISSIONS
  }.freeze

  private

  # Permissions are checked based off of the person having an associated
  # active group. The group query is scoped via acts_as_tenant which is
  # set from the Current.organization. Only active groups from the
  # Current.organization are returned. If Acts_as_tenant.current_tenant is
  # not set and Current.organization is present an error will be raised
  # via the Acts_as_tenant initializer.
  def active_group_names
    person_groups
      .where(deactivated_at: nil)
      .includes(:group)
      .map { |pg| pg.group.name }
  end

  def permissions
    active_group_names.flat_map do |role_name|
      PERMISSIONS[role_name.to_sym] || []
    end.uniq
  end
end
