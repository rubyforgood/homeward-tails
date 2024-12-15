#
# The FormSubmission model binds together a set of submitted answers from an adopter into a single submission. This represents a snapshot in time.
# If an adopter submits answers either through an in-app form or a third party form that is uploaded to the app,
# we will have a set of answers belonging to a form submission.
# This form submission can be valid for a period of time to allow the user to apply to adopt multiple pets.
# If this time expires, or the person's context changes and they need to update their responses, we now have a new set of answers and a new form submission.
#
# == Schema Information
#
# Table name: form_submissions
#
#  id              :bigint           not null, primary key
#  csv_timestamp   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  person_id       :bigint           not null
#
# Indexes
#
#  index_form_submissions_on_organization_id  (organization_id)
#  index_form_submissions_on_person_id        (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (person_id => people.id)
#
class FormSubmission < ApplicationRecord
  acts_as_tenant(:organization)
  belongs_to :person

  has_many :form_answers, dependent: :destroy

  delegate :user, to: :person

  validates :csv_timestamp, presence: true
end
