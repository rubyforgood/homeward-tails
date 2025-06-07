# frozen_string_literal: true

require "test_helper"

class AvatarComponentTest < ViewComponent::TestCase
  setup do
    @organization = create(:organization)
    @user = create(:user)
    @person = create(:person, user: @user, organization: @organization, first_name: "John", last_name: "Doe")
    @component = AvatarComponent.new(@user)
  end

  context "when user has attached avatar image" do
    setup do
      organization = create(:organization)
      user = create(:user)
      create(:person, user: user, organization: organization, first_name: "Jane", last_name: "Smith")
      user.avatar.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "logo.png")), filename: "logo.png")
      @component = AvatarComponent.new(user)
    end

    should "use the image_url as image src" do
      Current.stubs(:person).returns(@person)

      render_inline(@component)

      assert_selector("img", count: 1)
    end
  end

  context "when user does not have attached avatar image" do
    should "use user's initials as avatar" do
      Current.stubs(:person).returns(@person)

      render_inline(@component)

      assert_text("JD") # John Doe initials
      assert_selector("span.avatar-initials", count: 1)
    end
  end
  context "when rendered with size :md" do
    setup do
      organization = create(:organization)
      user = create(:user)
      create(:person, user: user, organization: organization, first_name: "Test", last_name: "User")
      @component = AvatarComponent.new(user, size: :md)
    end

    should "use md container classes" do
      Current.stubs(:person).returns(@person)

      render_inline(@component)

      assert_selector(".avatar.avatar-md.avatar-primary", count: 1)
    end
  end

  context "when rendered with size :xl" do
    setup do
      organization = create(:organization)
      user = create(:user)
      create(:person, user: user, organization: organization, first_name: "Test", last_name: "User")
      @component = AvatarComponent.new(user, size: :xl)
    end

    should "use xl container classes" do
      Current.stubs(:person).returns(@person)

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
