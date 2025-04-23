# Module to change User roles using Rolify methods
module RoleChangeable
  extend ActiveSupport::Concern

  def change_role(previous, new)
    # TODO raise error if current org is not set
    ActiveRecord::Base.transaction do
      remove_role(previous, Current.organization)
      add_role(new, Current.organization)
    end
  rescue
    false
  end
end
