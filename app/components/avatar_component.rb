# frozen_string_literal: true

# Renders a User's avatar as image or user's initials
class AvatarComponent < ApplicationComponent
  param :user, Types::Instance(User)
  option :size, Types::Size, default: -> { :md }

  private

  def avatar
    if image_url
      image_tag(url(image_url), alt: alt, class: image_classes)
    else
      content_tag(:span, initials, class: initials_classes)
    end
  end

  def image_url
    @user.avatar.attached? ? url_for(@user.avatar) : nil
  end

  def initials
    "#{user.first_name[0]}#{user.last_name[0]}".upcase
  end

  def alt
    "#{user.first_name.capitalize}'s avatar"
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
