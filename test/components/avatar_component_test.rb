# frozen_string_literal: true

require "test_helper"

class AvatarComponentTest < ViewComponent::TestCase
  setup do
    @person = create(:person)
    @component = AvatarComponent.new(@person)
  end

  context "when user has attached avatar image" do
    setup do
      user = create(:user, :with_avatar)
      person = create(:person, user: user)
      @component = AvatarComponent.new(person)
    end

    should "use the image_url as image src" do
      url = "/example.png"
      stub(:url_for, url) do
        render_inline(@component)

        assert_selector("img[src='#{url}']", count: 1)
      end
    end
  end

  context "when user does not have attached avatar image" do
    should "use user's initials as avatar" do
      render_inline(@component)

      assert_text("#{@person.first_name[0]}#{@person.last_name[0]}".upcase)
      assert_selector("span.avatar-initials", count: 1)
    end
  end

  context "when rendered with size :md" do
    setup do
      person = create(:person)
      @component = AvatarComponent.new(person, size: :md)
    end

    should "use md container classes" do
      render_inline(@component)

      assert_selector(".avatar.avatar-md.avatar-primary", count: 1)
    end
  end

  context "when rendered with size :xl" do
    setup do
      person = create(:person)
      @component = AvatarComponent.new(person, size: :xl)
    end

    should "use xl container classes" do
      render_inline(@component)

      assert_selector(".avatar.avatar-xl.avatar-primary.rounded-circle.border.border-4.border-white", count: 1)
    end
  end

  # context "#filter_attribute" do
  #   context "when value is nil" do
  #     should "return default" do
  #       assert_equal :default,
  #         @component.filter_attribute(nil, nil, default: :default)
  #     end
  #   end
  #
  #   context "when value is included in allowed_values" do
  #     should "return value" do
  #       assert_equal :value,
  #         @component.filter_attribute(:value, [:value], default: :default)
  #     end
  #   end
  #
  #   context "when value is not included in allowed_values" do
  #     should "return default" do
  #       assert_equal :default,
  #         @component.filter_attribute(:value, [], default: :default)
  #     end
  #   end
  # end
end
