# == Schema Information
#
# Table name: notes
#
#  id           :bigint           not null, primary key
#  notable_type :string           not null
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notable_id   :bigint           not null
#
# Indexes
#
#  index_notes_on_notable  (notable_type,notable_id)
#
class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
end
