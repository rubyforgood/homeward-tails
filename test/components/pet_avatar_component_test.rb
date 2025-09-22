require "test_helper"

class PetAvatarComponentTest < ViewComponent::TestCase
  context "when pet does and does not exists" do
    setup do
      @pet_with_image = create(:pet, :with_image)
      @pet_without_image = create(:pet)
    end

    should "has and image" do
      url = "/example.png"
      stub(:url_for, url) do
        render_inline(@component)
        assert_selector("img[src='#{url_for(@pet_with_image.images.first)}']", count: 1)
      end
    end

    should "does not have an image but shows initials" do
      url = "/example.png"
      stub(:url_for, url) do
        @component = AvatarComponent.new(pet: @pet_without_image)
        render_inline(@component)
        assert_selector(@pet_without_image.name[0, 2].upcase)
      end
    end
  end
end
