# frozen_string_literal: true

#
# Used as the base controller of all controllers that are scoped to an organization
# so that the tenant is properly set and everything is scoped to the organization to
# achieve multi-tenancy.
#

class Organizations::BaseController < ApplicationController
  include OrganizationScopable
end
