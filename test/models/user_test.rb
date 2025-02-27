# frozen_string_literal: true

require "test_helper"
require "shared/avatarable_shared_tests"

class UserTest < ActiveSupport::TestCase
  include AvatarableSharedTests

  context "associations" do
    should have_many(:people)
  end

  context "validations" do
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:email)

    should "validate uniqueness of email scoped to organization" do
      user = create(:user)
      assert user.valid?

      user2 = build(:user, email: user.email)
      assert user2.invalid?
    end
  end

  context "creation" do
    should "attach to an existing person" do
      # TODO: This fails because User.rb tries to create a person
      # with the same email on create. User matches person
      # by the user_id FK hence does not find the person
      # created here. We need to figure out how the person
      # creation logic should work.

      person = create(:person, email: "adopter@example.com")
      user = create(:user, email: "adopter@example.com")

      assert_equal person, user.person
    end

    should "not attach to people in other organizations" do
      person = nil

      # debugger
      ActsAsTenant.with_tenant(create(:organization)) do
        person = create(:person, email: "adopter@example.com")
      end

      assert_equal("adopter@example.com", person.email)

      user = create(:user, email: "adopter@example.com")
      assert_not_equal person, user.person
    end

    should "create a person if none exists" do
      user = create(:user, email: "tester@example.com", first_name: "Jane", last_name: "Smith")

      assert_equal "Jane", user.person.first_name
      assert_equal "Smith", user.person.last_name
      assert_equal "tester@example.com", user.person.email
    end
  end

  context ".staff" do
    should "return all admin users" do
      user = create(:admin)
      assert_includes User.staff, user

      user.people.destroy
      # TODO: This fails due to the FK constraint in the Person table.
      # Options:
      # 1. Add dependent: :destroy
      # 2. Add logic to delete associated people first (samae as above
      # but with a bit more control)
      # 3. Block user deletion (can be context aware)
      # 4. etc..
      # user.destroy
      # assert_not_includes User.staff, user
    end
  end

  context "#full_name" do
    context "format is :default" do
      should "return `First Last`" do
        user = build(:user, first_name: "First", last_name: "Last")

        assert_equal "First Last", user.full_name
      end
    end

    context "format is :default" do
      should "return `First Last`" do
        user = build(:user, first_name: "First", last_name: "Last")

        assert_equal "First Last", user.full_name(:default)
      end
    end

    context "format is :last_first" do
      should "return `Last, First`" do
        user = build(:user, first_name: "First", last_name: "Last")

        assert_equal "Last, First", user.full_name(:last_first)
      end
    end

    context "format is unsupported" do
      should "raise ArgumentError" do
        user = build(:user, first_name: "First", last_name: "Last")

        assert_raises(ArgumentError) { user.full_name(:foobar) }
      end
    end
  end

  private

  def fixture_file
    @fixture_file ||= load_file
  end

  def load_file
    fixture_path = File.join(Rails.root, "test", "fixtures", "files", "logo.png")
    File.open(fixture_path)
  end
end
