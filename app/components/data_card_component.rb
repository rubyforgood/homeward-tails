class DataCardComponent < ViewComponent::Base
  attr_reader :title_size, :icon_color

  def initialize(title_size: :medium, icon_color: nil)
    @title_size = title_size
    @icon_color = icon_color
  end

  renders_one :title
  renders_one :icon_name
  renders_one :value

  private

  # Uses feather icons (app/assets/stylesheets/feather.css)
  def feather_classes
    "fe fe-#{icon_name}"
  end

  def title_size_class
    case title_size
    when :small
      "fs-6" # Equivalent to h4
    when :medium
      "fs-4" # Equivalent to h3
    when :large
      "fs-3" # Equivalent to h1
    else
      "fs-4" # Default to medium
    end
  end
end
