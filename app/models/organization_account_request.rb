class OrganizationAccountRequest
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :name, :email, :requester_name, :phone_number, :city_town, :country, :province_state

  before_validation :normalize_phone

  validates :name, :email, :requester_name, :city_town, :country, :province_state, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :phone_number, presence: true, phone: {possible: true, allow_blank: true}

  private

  def normalize_phone
    self.phone_number = Phonelib.parse(phone_number).full_e164.presence
  end
end
