# == Schema Information
#
# Table name: tasks
#
#  id                    :bigint           not null, primary key
#  completed             :boolean          default(FALSE)
#  description           :text
#  due_date              :datetime
#  name                  :string           not null
#  next_due_date_in_days :integer
#  recurring             :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  organization_id       :bigint           not null
#  pet_id                :bigint           not null
#
# Indexes
#
#  index_tasks_on_organization_id  (organization_id)
#  index_tasks_on_pet_id           (pet_id)
#
# Foreign Keys
#
#  fk_rails_...  (pet_id => pets.id)
#
class Task < ApplicationRecord
  acts_as_tenant(:organization)
  belongs_to :pet

  validates :name, presence: true
  validates :description, presence: true
  validates :next_due_date_in_days, numericality: {only_integer: true, allow_nil: true}
  validate :next_due_date_when_sensible

  scope :is_not_completed, -> { where(completed: false).or(where(completed: nil)) }
  scope :is_completed, -> { where(completed: true) }
  scope :has_due_date, -> { where.not(due_date: nil).order(due_date: :asc) }
  scope :no_due_date, -> { where(due_date: nil).order(updated_at: :desc) }
  scope :not_overdue, -> { where("(due_date >= ? OR due_date IS NULL)", Time.current) }
  scope :overdue, -> { where("(due_date < ? )", Time.current) }

  def overdue?
    due_date_passed? && !completed
  end

  def due_date_passed?
    due_date < Time.current if due_date
  end

  def self.list_ordered
    Task.is_not_completed.has_due_date +
      Task.is_not_completed.no_due_date +
      Task.is_completed.has_due_date +
      Task.is_completed.no_due_date
  end

  private

  def next_due_date_when_sensible
    if next_due_date_in_days && (!due_date || !recurring)
      errors.add(:base, "A task must be recurring and have a due date in order to set next due date in days value.")
    elsif !next_due_date_in_days && recurring && due_date
      errors.add(:base, "Recurring tasks with due dates must set a next due date in days value.")
    end
  end
end
