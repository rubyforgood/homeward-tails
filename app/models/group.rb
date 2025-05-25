# == Schema Information
#
# Table name: groups
#
#  id              :bigint           not null, primary key
#  name            :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_groups_on_name_and_organization_id  (name,organization_id) UNIQUE
#  index_groups_on_organization_id           (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Group < ApplicationRecord
  acts_as_tenant(:organization)

  has_many :person_groups
  has_many :people, through: :person_groups
  enum :name, %i[adopter fosterer admin super_admin]

  validates_uniqueness_to_tenant :name
end
