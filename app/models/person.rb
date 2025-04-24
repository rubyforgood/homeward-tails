# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  phone_number    :string(15)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  user_id         :bigint
#
# Indexes
#
#  index_people_on_email            (email)
#  index_people_on_organization_id  (organization_id)
#  index_people_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class Person < ApplicationRecord
  include Avatarable
  include Phoneable
  include Exportable

  acts_as_tenant(:organization)

  has_one :latest_form_submission, -> { order(created_at: :desc) }, class_name: "FormSubmission"
  has_many :form_submissions, dependent: :destroy
  has_many :form_answers, through: :form_submissions
  has_many :adopter_applications, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_pets, through: :likes, source: :pet
  has_one :location, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :location,
    reject_if: ->(attributes) { attributes["city_town"].blank? }
  has_many :matches # , dependent: :destroy
  belongs_to :user, optional: true
  has_many :person_groups
  has_many :groups, through: :person_groups

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false, scope: :organization_id}
  validates :user_id, uniqueness: {scope: :organization_id}, allow_nil: true
  validates :phone_number, phone: true, if: :phone_number?

  scope :adopters, -> {
    joins(:groups).where(groups: {name: "adopter"})
  }

  scope :fosterers, -> {
    joins(:groups).where(groups: {name: "fosterer"})
  }

  scope :staff, -> {
    joins(:groups).where(groups: {name: ["admin", "super_admin"]})
  }

  scope :active_staff, -> {
    joins(groups: :person_groups)
      .where(groups: {name: ["admin", "super_admin"]})
      .where(person_groups: {deactivated_at: nil})
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name email]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[matches]
  end

  def full_name(format = :default)
    case format
    when :default
      "#{first_name} #{last_name}"
    when :last_first
      "#{last_name}, #{first_name}"
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end
  end

  def add_role_and_group(*names)
    transaction do
      names.each do |name|
        user.add_role(name, Current.organization)
      end
      add_group(*names)
    end
  end

  def add_group(*names)
    names.map(&:to_s).uniq.each do |name|
      next unless Group.names.key?(name)
      group = Group.find_or_create_by!(name: name)

      unless groups.exists?(id: group.id)
        person_groups.create!(group: group)
      end
    end
  end

  def is_staff?
    groups.exists?(name: %i[admin super_admin])
  end

  def current_staff_group
    groups.find_by(name: ["admin", "super_admin"])&.name
  end

  def is_active_staff?
    active_in_group?(current_staff_group)
  end

  def add_or_change_staff_role_and_group(new_group, prev_group = nil)
    transaction do
      user.change_role(prev_group, new_group)

      # Remove existing admin/super_admin groups
      groups.where(name: [:admin, :super_admin]).each do |group|
        groups.destroy(group)
      end

      add_group(new_group)
    end
  end

  def active_in_group?(name)
    person_groups.joins(:group)
      .where(deactivated_at: nil, groups: {name: name})
      .exists?
  end

  def person_group_for(group_name)
    group = Group.find_by(name: group_name)
    return nil unless group

    person_groups.find_by(group_id: group.id)
  end

  def deactivated_in_org?
    !person_groups
      .joins(:group)
      .where(deactivated_at: nil)
      .exists?
  end
end
