class PersonGroup < ApplicationRecord
  belongs_to :person
  belongs_to :group

  validates :person_id, uniqueness: {scope: :group_id}
end
