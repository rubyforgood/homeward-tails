require "test_helper"

class LikeButtonComponentTest < ViewComponent::TestCase
  context "with like" do
    setup do
      like = create(:like)
      render_inline(LikeButtonComponent.new(like: like, pet: like.pet))
    end

    should "render liked image" do
      assert_selector("img[src*='liked']", count: 1)
    end

    should "render button to unlike" do
      assert_selector("form[method='post'] input[type='hidden'][name='_method'][value='delete']", visible: false, count: 1)
      assert_selector("form[method='post'] button[type='submit']", count: 1)
    end
  end

  context "without like" do
    setup do
      pet = create(:pet)
      render_inline(LikeButtonComponent.new(like: nil, pet: pet))
    end

    should "render unliked image" do
      assert_selector("img[src*='unliked']", count: 1)
    end

    should "render button to like" do
      assert_no_selector("form[method='post'] input[type='hidden'][name='_method'][value='delete']", visible: false, count: 1)
      assert_selector("form[method='post'] button[type='submit']", count: 1)
    end
  end
end
