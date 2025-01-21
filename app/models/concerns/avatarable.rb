module Avatarable
  extend ActiveSupport::Concern

  included do
    # Added to avoid running into a error when precompiling which
    # forces Azure to be defined
    has_one_attached :avatar unless ENV["PRECOMPILING"]

    validates :avatar,
      content_type: {in: ["image/png", "image/jpeg"], message: I18n.t(".content_type_invalid")},
      size: {less_than: 1.megabytes, message: :file_size_not_less_than}
  end
end
