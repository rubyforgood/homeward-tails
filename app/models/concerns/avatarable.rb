module Avatarable
  extend ActiveSupport::Concern

  included do
    # Added to avoid running into a error when precompiling which 
    # forces Azure to be defined
    has_one_attached :avatar unless ENV["PRECOMPILING"]

    # TODO:  move these validation strings to a locale file
    validates :avatar, content_type: {in: ["image/png", "image/jpeg"],
      message: "must be PNG or JPEG"},
      size: {between: 10.kilobyte..1.megabytes,
        message: "size must be between 10kb and 1Mb"}
  end
end
