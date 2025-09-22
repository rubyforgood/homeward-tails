require "test_helper"

class NavTabComponentTest < ViewComponent::TestCase
  setup do
    @component = NavTabComponent.new(url: "/foo", text: "bar")
  end

  should "render nav list item" do
    render_inline(@component)

    assert_selector("li.nav-item", text: "bar", count: 1)
  end

  should "render nav link" do
    render_inline(@component)

    assert_selector("a.nav-link[href='/foo']", text: "bar", count: 1)
  end
end
