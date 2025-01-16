# frozen_string_literal: true

#
# Used as the base controller of all controllers that are scoped to an organization
# so that the tenant is properly set and everything is scoped to the organization to
# achieve multi-tenancy.
#

class TosAgreementError < StandardError; end

class Organizations::BaseController < ApplicationController
  include OrganizationScopable

  before_action :verify_tos_accepted, if: :user_signed_in?

  rescue_from TosAgreementError do
    flash[:alert] = "You must accept the Terms of Service before continuing."

    redirect_to edit_agreement_path
  end

  def verify_tos_accepted
    raise TosAgreementError unless current_user.tos_agreement?
  end
end
