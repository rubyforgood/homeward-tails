# Module to handle phone number normalization before save and formatting
# Note that we are not handling all validation here as different models may have different validation requirements (e.g. presence)
module Phoneable
  extend ActiveSupport::Concern

  included do
    before_save :normalize_phone

    validates :phone_number, phone: true, if: :phone_number?

    def formatted_phone_number
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

    private

    def normalize_phone
      self.phone_number = Phonelib.parse(phone_number).full_e164.presence
    end
  end
end
