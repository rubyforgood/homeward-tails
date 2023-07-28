# == Schema Information
#
# Table name: adopter_profiles
#
#  id                 :bigint           not null, primary key
#  activities         :text
#  adults_in_home     :integer
#  alone_weekday      :integer
#  alone_weekend      :integer
#  annual_cost        :string
#  checked_shelter    :boolean
#  city_town          :string
#  contact_method     :string
#  contingency_plan   :text
#  country            :string
#  describe_pets      :text
#  describe_surrender :text
#  do_you_rent        :boolean
#  experience         :text
#  fenced_access      :boolean
#  fenced_alternative :text
#  housing_type       :string
#  ideal_pet          :text
#  kids_in_home       :integer
#  lifestyle_fit      :text
#  location_day       :text
#  location_night     :text
#  other_pets         :boolean
#  pets_allowed       :boolean
#  phone_number       :string
#  province_state     :string
#  referral_source    :text
#  shared_owner       :text
#  shared_ownership   :boolean
#  surrendered_pet    :boolean
#  visit_dates        :text
#  visit_laventana    :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  adopter_account_id :bigint           not null
#
# Indexes
#
#  index_adopter_profiles_on_adopter_account_id  (adopter_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (adopter_account_id => adopter_accounts.id)
#
class AdopterProfile < ApplicationRecord
  belongs_to :adopter_account
  has_one :location, dependent: :destroy
  accepts_nested_attributes_for :location
  validates_associated :location

  before_save :normalize_phone

  # phonelib gem
  validates :phone_number, phone: {possible: true}

  validates :contact_method, presence: true
  validates :ideal_pet, presence: {message: "Please tell us about your ideal pet"},
    length: {maximum: 200, message: "200 characters maximum"}
  validates :lifestyle_fit, presence: {message: "Please tell us about your lifestyle"},
    length: {maximum: 200, message: "200 characters maximum"}
  validates :activities, presence: {message: "Please tell us about the activities"},
    length: {maximum: 200, message: "200 characters maximum"}
  validates :alone_weekday, presence: {message: "This field cannot be blank"}
  validates :alone_weekend, presence: {message: "This field cannot be blank"}
  validates :experience, presence: {message: "Please tell us about your pet experience"},
    length: {maximum: 200, message: "200 characters maximum"}
  validates :contingency_plan, presence: {message: "Please tell us about your contingencies"},
    length: {maximum: 200, message: "200 characters maximum"}
  validates_inclusion_of :shared_ownership, in: [true, false],
    message: "Select one"
  validates :shared_owner, presence: {message: "Please tell us about the alternate person"},
    length: {maximum: 200, message: "200 characters maximum"},
    if: :shared_owner_true?
  validates :housing_type, presence: true
  validates_inclusion_of :fenced_access, in: [true, false],
    message: "Select one"
  validates :fenced_alternative, presence: {message: "Please fill this field"},
    length: {maximum: 200, message: "200 characters maximum"},
    if: :fenced_access_false?
  validates :location_day, presence: true, length: {maximum: 100}
  validates :location_night, presence: true, length: {maximum: 100}
  validates_inclusion_of :do_you_rent, in: [true, false], message: "Select one"
  validates_inclusion_of :pets_allowed, in: [true, false],
    message: "Select one",
    if: :do_you_rent?
  validates :adults_in_home, presence: true
  validates :kids_in_home, presence: true
  validates_inclusion_of :other_pets, in: [true, false],
    message: "Select one"
  validates :describe_pets, presence: {message: "Please tell us about your other pets"},
    length: {maximum: 200, message: "200 characters maximum"},
    if: :other_pets?
  validates_inclusion_of :checked_shelter, in: [true, false],
    message: "Select one"
  validates_inclusion_of :surrendered_pet, in: [true, false],
    message: "Select one"
  validates :describe_surrender, presence: {message: "Please fill this field"},
    length: {maximum: 200, message: "200 characters maximum"},
    if: :surrendered_pet?
  validates :annual_cost, presence: {message: "Please provide an annual cost estimate"}
  validates_inclusion_of :visit_laventana, in: [true, false],
    message: "Select one"
  validates :visit_dates, presence: {message: "Please fill this field"},
    length: {maximum: 50, message: "50 characters maximum"},
    if: :visiting_laventana?
  validates :referral_source, presence: {message: "Please tell us how you heard about us"},
    length: {maximum: 50, message: "50 characters maximum"}

  def shared_owner_true?
    shared_ownership == true
  end

  def fenced_access_false?
    fenced_access == false
  end

  def do_you_rent?
    do_you_rent == true
  end

  def other_pets?
    other_pets == true
  end

  def surrendered_pet?
    surrendered_pet == true
  end

  def visiting_laventana?
    visit_laventana == true
  end

  def formatted_phone
    parsed_phone = Phonelib.parse(phone_number)
    return phone_number if parsed_phone.invalid?

    formatted =
      if parsed_phone.country_code == "1" # NANP
        parsed_phone.full_national # (415) 555-2671;123
      else
        parsed_phone.full_international # +44 20 7183 8750
      end
    formatted.gsub!(";", " x") # (415) 555-2671 x123
    formatted
  end

  # used in views to show only the custom error msg without leading attribute
  def custom_messages(attribute)
    errors.where(attribute)
  end

  private

  def normalize_phone
    self.phone_number = Phonelib.parse(phone_number).full_e164.presence
  end
end
