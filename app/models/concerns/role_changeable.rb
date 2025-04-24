# Module to change User roles using Rolify methods
module RoleChangeable
  extend ActiveSupport::Concern

  def change_role(previous, new)
    raise StandardError, "Organization not set" unless Current.organization

    ActiveRecord::Base.transaction do
      remove_role(previous, Current.organization)
      add_role(new, Current.organization)
    end
  rescue
    false
  end
end
