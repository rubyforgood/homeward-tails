# Renders a Pet's image and the Heart like button
class PetAvatarComponent < ApplicationComponent
  param :pet, Types::Instance(Pet)
  option :size, Types::Size, default: -> { :md }

  private

  def pet_avatar
    pet_image || pet_initials_span
  end

  def pet_image
    return unless pet.images.present? && pet.images.first.present?

    image_tag(url_for(pet.images.first), alt: pet.name, class: image_class)
  end

  def pet_initials_span
    return unless pet.name.present?

    content_tag(:span, pet_initials, class: initials_class)
  end

  def pet_initials
    pet.name[0].upcase
  end

  def image_class
    "rounded-circle"
  end

  def initials_class
    case size
    when :md
      "avatar-initials rounded-circle"
    when :xl
      "avatar-initials rounded-circle fs-2"
    end
  end

  def container_class
    case size
    when :md
      "avatar avatar-md avatar-primary rounded-circle border border-1 border-white"
    when :xl
      "avatar avatar-xl avatar-primary rounded-circle border border-4 border-white"
    end
  end
end
