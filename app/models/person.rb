# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string           not null
#  phone           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_people_on_email            (email)
#  index_people_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Person < ApplicationRecord
  include Avatarable

  acts_as_tenant(:organization)

  validates :name, presence: true
  validates :email, presence: true,
    uniqueness: {case_sensitive: false, scope: :organization_id}
end
