class AddExternalFormUrlToOrganizations < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :external_form_url, :text
  end
end
