class RenameSubdomainToSlugOnOrganizations < ActiveRecord::Migration[7.0]
  def change
    rename_column :organizations, :subdomain, :slug
  end
end
