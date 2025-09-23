require "test_helper"

class BadgeComponentTest < ViewComponent::TestCase
  context "with defaults" do
    setup do
      render_inline(BadgeComponent.new("default badge"))
    end

    should "render with 'badge' class" do
      assert_selector("span.badge")
    end
  end

  context "with label" do
    setup do
      render_inline(BadgeComponent.new("treat thief"))
    end

    should "render with label" do
      assert_selector("span", text: "treat thief")
    end
  end

  context "with class" do
    setup do
      render_inline(BadgeComponent.new("test", class: "text-test"))
    end

    should "render with class" do
      assert_selector("span.text-test")
    end
  end

  context "with condition" do
    context "when condition is true" do
      setup do
        render_inline(BadgeComponent.new("test", when: true))
      end

      should "render" do
        assert_selector("span", text: "test")
      end
    end

    context "when condition is false" do
      setup do
        render_inline(BadgeComponent.new("test", when: false))
      end

      should "not render" do
        assert_equal("", rendered_content)
      end
    end
  end
end
