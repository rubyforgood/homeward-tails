class Group < ApplicationRecord
  acts_as_tenant(:organization)

  has_many :person_groups
  has_many :people, through: :person_groups
  enum :name, %i[adopter fosterer admin super_admin]
end
