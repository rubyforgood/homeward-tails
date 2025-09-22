class ImageAttachmentTableComponent < ViewComponent::Base
  attr_reader :images

  def initialize(images:)
    @images = images
  end
end
