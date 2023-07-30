# == Schema Information
#
# Table name: checklist_template_items
#
#  id                     :bigint           not null, primary key
#  description            :text
#  expected_duration_days :integer          not null
#  name                   :string           not null
#  required               :boolean          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  checklist_template_id  :bigint           not null
#
# Indexes
#
#  index_checklist_template_items_on_checklist_template_id  (checklist_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (checklist_template_id => checklist_templates.id)
#
class ChecklistTemplateItem < ApplicationRecord
  belongs_to :checklist_template
  validates :name, :expected_duration_days, presence: true
  has_many :checklist_assignments, dependent: :destroy
end
