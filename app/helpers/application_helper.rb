module ApplicationHelper
  include ::Pagy::Frontend

  #
  # Returns the path to the home page of the organization.
  #
  #
  def organization_home_path(organization)
    home_index_path(script_name: "/#{organization.slug}")
  end

  def path_to_partial(active_tab)
    "pets/#{active_tab}"
  end

  def current_organization_name
    if Current.organization.present?
      Current.organization.name
    else
      Current.tenant.name
    end
  end

  def default_country(organization = Current.organization)
    organization.locations.first&.country || ""
  end
end
