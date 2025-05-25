# == Schema Information
#
# Table name: notes
#
#  id              :bigint           not null, primary key
#  content         :text
#  notable_type    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notable_id      :bigint           not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_notes_on_notable          (notable_type,notable_id)
#  index_notes_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Note < ApplicationRecord
  acts_as_tenant(:organization)

  belongs_to :notable, polymorphic: true
end
