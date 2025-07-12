# == Schema Information
#
# Table name: organizations
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE), not null
#  donation_url      :text
#  email             :string           not null
#  external_form_url :text
#  facebook_url      :text
#  instagram_url     :text
#  name              :string           not null
#  phone_number      :string
#  slug              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_organizations_on_active  (active)
#  index_organizations_on_slug    (slug) UNIQUE
#
class Organization < ApplicationRecord
  include Avatarable
  include Phoneable

  has_many :users, through: :people, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :default_pet_tasks, dependent: :destroy
  has_many :forms, class_name: "CustomForm::Form", dependent: :destroy
  has_many :faqs, dependent: :destroy

  has_many :form_answers, dependent: :destroy
  has_many :people, dependent: :destroy
  has_one :form_submission, dependent: :destroy
  has_one :custom_page, dependent: :destroy

  has_many :locations, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :locations

  validates :phone_number, phone: {possible: true, allow_blank: true}
  validates :name, presence: true
  validates :slug, presence: true, format: {with: /\A[a-zA-Z0-9_-]+\z/, message: "only allows letters, numbers, hyphens, and underscores"}
  validates :email, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :facebook_url, url: true, allow_blank: true
  validates :instagram_url, url: true, allow_blank: true
  validates :donation_url, url: true, allow_blank: true

  scope :active, -> { where(active: true) }
end
