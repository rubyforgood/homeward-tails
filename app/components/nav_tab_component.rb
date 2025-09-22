class NavTabComponent < ViewComponent::Base
  attr_reader :url, :text

  def initialize(url:, text:)
    @url = url
    @text = text
  end
end
