ActsAsTenant.configure do |config|
  # If you change this, ensure all authorization policies/permissions are checked thoroughly!
  config.require_tenant = -> { Current.organization.present? }
end
