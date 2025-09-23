class Current < ActiveSupport::CurrentAttributes
  # Set attributes to be available in the entire stack
  attribute :organization, :person
  alias_method :tenant, :organization
end
