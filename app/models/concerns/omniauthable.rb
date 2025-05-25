module Omniauthable
  extend ActiveSupport::Concern

  included do
    devise :omniauthable, omniauth_providers: [:google_oauth2]
  end

  class_methods do
    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.assign_attributes_from_auth(auth)
        user.set_adopter_role
      end
    end
  end

  def assign_attributes_from_auth(auth)
    self.email = auth.info.email
    self.password = Devise.friendly_token[0, 20]
    self.first_name = auth.info.first_name if respond_to?(:first_name)
    self.last_name = auth.info.last_name if respond_to?(:last_name)
  end

  def set_adopter_role
    # TODO: Verify this works

    person = Person.find_or_create_by!(email: email) do |person|
      person.user_id = id
      person.first_name = first_name
      person.last_name = last_name
    end

    person.add_group(:adopter)
  end
end
