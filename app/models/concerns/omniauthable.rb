module Omniauthable
  extend ActiveSupport::Concern

  included do
    devise :omniauthable, omniauth_providers: [:google_oauth2]
  end

  class_methods do
    def from_omniauth(auth)
      user = where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
        u.assign_attributes_from_auth(auth)
      end

      if user.persisted?
        user.set_adopter_role(auth)
      end
      user
    end
  end

  def assign_attributes_from_auth(auth)
    self.email = auth.info.email
    self.password = Devise.friendly_token[0, 20]
  end

  def set_adopter_role(auth)
    # Create person record in current organization context
    if ActsAsTenant.current_tenant
      person = Person.find_or_create_by(
        user: self,
        organization: ActsAsTenant.current_tenant
      ) do |p|
        p.email = email
        p.first_name = auth.info.first_name || ""
        p.last_name = auth.info.last_name || ""
      end

      # Add adopter role if person doesn't have any groups
      if person.groups.empty?
        person.add_group(:adopter)
      end
    end
  end

  def was_just_created?
    @was_just_created || false
  end
end
