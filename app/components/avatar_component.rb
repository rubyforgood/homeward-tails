# Renders a User's avatar as image or user's initials
class AvatarComponent < ApplicationComponent
  param :person, Types::Instance(Person)
  option :size, Types::Size, default: -> { :md }

  private

  def avatar
    if image_url
      image_tag(image_url, alt: alt, class: image_classes)
    else
      content_tag(:span, initials, class: initials_classes)
    end
  end

  def image_url
    person.user.avatar.attached? ? url_for(person.user.avatar) : nil
  end

  def initials
    "#{person.first_name[0]}#{person.last_name[0]}".upcase
  end

  def alt
    "#{person.first_name.capitalize}'s avatar"
  end

  def container_classes
    case size
    when :md
      "avatar avatar-md avatar-primary"
    when :xl
      "avatar avatar-xl avatar-primary rounded-circle border border-4 border-white"
    end
  end

  def image_classes
    "rounded-circle"
  end

  def initials_classes
    case size
    when :md
      "avatar-initials rounded-circle"
    when :xl
      "avatar-initials rounded-circle fs-2"
    end
  end
end
