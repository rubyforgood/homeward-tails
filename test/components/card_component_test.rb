require "test_helper"

class CardComponentTest < ViewComponent::TestCase
  context "with default options" do
    setup do
      render_inline(CardComponent.new) do |c|
        c.with_header { "card header" }
        c.with_body { "card body" }
      end
    end

    should "render card" do
      assert_selector("div.card.card-hover", count: 1)
    end

    should "render card header with default class" do
      assert_selector("div.card-header", text: "card header", count: 1)
    end

    should "render card body with default class" do
      assert_selector("div.card-body", text: "card body", count: 1)
    end

    should "render coming_soon image" do
      assert_selector("img[src*='coming_soon'].card-img-top", count: 1)
    end
  end

  context "with badge slot" do
    setup do
      render_inline(CardComponent.new) do |c|
        c.with_badge { "card badge" }
        c.with_body { "card body" }
      end
    end

    should "render card" do
      assert_selector("div.card.card-hover", count: 1)
    end

    should "render badge" do
      assert_selector("div.position-absolute.top-0.end-0.m-2", text: "card badge", count: 1)
    end
  end

  context "with custom options" do
    context "with image src and url options" do
      setup do
        render_inline(CardComponent.new(
          image_options: {
            src: "/example.png",
            url: "https://example.com"
          }
        ))
      end

      should "render image" do
        assert_selector("img[src*='example.png']", count: 1)
      end

      should "render link" do
        assert_selector("a[href*='https://example.com']", count: 1)
      end
    end

    context "with header options" do
      setup do
        render_inline(CardComponent.new(
          header_options: {
            class: "custom-class"
          }
        )) do |c|
          c.with_header { "card header" }
        end
      end

      should "render header with custom classes" do
        assert_selector("div.custom-class", text: "card header", count: 1)
      end
    end

    context "with body options" do
      setup do
        render_inline(CardComponent.new(
          body_options: {
            class: "custom-class"
          }
        )) do |c|
          c.with_body { "card body" }
        end
      end

      should "render body with custom classes" do
        assert_selector("div.custom-class", text: "card body", count: 1)
      end
    end
  end
end
