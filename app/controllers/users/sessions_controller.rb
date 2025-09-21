# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include OrganizationScopable

  layout "application"

  skip_before_action :verify_person_in_org, only: :destroy
end
