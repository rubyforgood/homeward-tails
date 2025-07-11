class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_verify_authorized only: %i[about_us cookie_policy donate partners
    privacy_policy terms_and_conditions organizations]

  before_action :require_no_tenant, only: [:about_us, :partners]

  def home
    if !current_tenant
      render :no_tenant and return
    end
  end

  def about_us
  end

  def partners
  end

  def donate
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def cookie_policy
  end

  def organizations
    @organizations = Organization
      .includes(:custom_page, :locations)
  end

  private

  def require_no_tenant
    unless Current.organization.blank?
      render "errors/not_found", status: :not_found and return
    end
  end
end
