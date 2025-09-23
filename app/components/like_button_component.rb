class LikeButtonComponent < ViewComponent::Base
  attr_reader :like, :pet

  def initialize(like:, pet:)
    @like = like
    @pet = pet
  end
end
