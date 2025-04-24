# == Schema Information
#
# Table name: person_groups
#
#  id             :bigint           not null, primary key
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  group_id       :bigint           not null
#  person_id      :bigint           not null
#
# Indexes
#
#  index_person_groups_on_group_id                (group_id)
#  index_person_groups_on_person_id               (person_id)
#  index_person_groups_on_person_id_and_group_id  (person_id,group_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (person_id => people.id) ON DELETE => cascade
#
class PersonGroup < ApplicationRecord
  belongs_to :person
  belongs_to :group

  validates :person_id, uniqueness: {scope: :group_id}
  def activated?
    deactivated_at.nil?
  end

  def deactivated?
    !activated?
  end
end
