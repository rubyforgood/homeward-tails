require "dry-initializer"
require "dry-types"

class ApplicationComponent < ViewComponent::Base
  extend Dry::Initializer

  module Types
    include Dry.Types()

    # Custom types
    ImageTagSource =
      Types::String |
      Types::Symbol |
      Types::Integer |
      Types::Nil |
      Types::Instance(ActiveStorage::Attachment) |
      Types::Instance(ActiveStorage::Attached::One) |
      Types::Instance(ActiveStorage::Attached::Many)

    Size =
      Types::Symbol.enum(:md, :xl)
  end
end
