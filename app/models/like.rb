# == Schema Information
#
# Table name: likes
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  person_id       :bigint           not null
#  pet_id          :bigint           not null
#
# Indexes
#
#  index_likes_on_organization_id  (organization_id)
#  index_likes_on_person_id        (person_id)
#  index_likes_on_pet_id           (pet_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (pet_id => pets.id)
#
class Like < ApplicationRecord
  belongs_to :pet
  belongs_to :person
  acts_as_tenant(:organization)

  validates :person_id, uniqueness: {scope: :pet_id}
end
