class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  skip_verify_authorized only: %i[
    about_us
    cookie_policy
    partners
    privacy_policy
    terms_and_conditions
    organizations
  ]

  before_action :require_no_tenant, only: [:about_us, :partners, :organizations]

  def home
    if Current.organization.blank?
      render :no_tenant
    end
  end

  def about_us
  end

  def partners
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def cookie_policy
  end

  def organizations
    @organizations = Organization.active.includes(:custom_page, :locations)
  end

  private

  def require_no_tenant
    if Current.organization.present?
      render "errors/not_found", status: :not_found
    end
  end
end
