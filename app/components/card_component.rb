# frozen_string_literal: true

# Renders a card component
class CardComponent < ApplicationComponent
  option :card_options,
    Types::Hash.schema(
      class?: Types::String.default("card card-hover")
    ),
    default: -> { {} }

  option :header_options,
    Types::Hash.schema(
      class?: Types::String.default("card-header")
    ),
    default: -> { {} }

  option :body_options,
    Types::Hash.schema(
      class?: Types::String.default("card-body")
    ),
    default: -> { {} }

  option :image_options,
    Types::Hash.schema(
      src?: Types::ImageTagSource,
      class?: Types::String.default("card-img-top"),
      url?: Types::String,
      style: Types::String.default("object-fit: cover;"),
      height?: Types::Integer.default(150),
      default?: Types::ImageTagSource.default("coming_soon.jpg")
    ),
    default: -> { {} }

  renders_one :header
  renders_one :body
  renders_one :badge

  private

  def image_src
    @image_src ||= image_options[:src] || image_options[:default]
  end
end
