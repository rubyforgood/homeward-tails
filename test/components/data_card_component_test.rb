require "test_helper"

class DataCardComponentTest < ViewComponent::TestCase
  setup do
    @component = DataCardComponent.new
  end

  context "with slots" do
    setup do
      @component = DataCardComponent.new.tap do |c|
        c.with_title { "title" }
        c.with_icon_name { "icon" }
        c.with_value { "37" }
      end
      render_inline(@component)
    end

    should "render card title" do
      assert_text("title")
    end

    should "render card icon" do
      assert_selector("span.fe.fe-icon", count: 1)
    end

    should "render card value" do
      assert_text("37")
    end
  end

  context "without icon_name slot" do
    setup do
      @component = DataCardComponent.new.tap do |c|
        c.with_title { "title" }
        c.with_value { "37" }
      end
      render_inline(@component)
    end

    should "render card title" do
      assert_text("title")
    end

    should "not render card icon" do
      assert_selector("span.fe", count: 0)
    end

    should "render card value" do
      assert_text("37")
    end
  end
end
