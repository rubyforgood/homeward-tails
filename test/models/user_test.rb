# frozen_string_literal: true

require "test_helper"
require "shared/avatarable_shared_tests"

class UserTest < ActiveSupport::TestCase
  include AvatarableSharedTests

  context "associations" do
    should have_many(:people)
    should have_many(:organizations).through(:people)
  end

  context "validations" do
    should validate_presence_of(:email)
  end

  context "#full_name" do
    setup do
      @organization = create(:organization)
      @user = create(:user)
      @person = create(:person, user: @user, organization: @organization, first_name: "First", last_name: "Last")
    end

    context "format is :default" do
      should "return `First Last` from current person" do
        Current.stubs(:person).returns(@person)

        assert_equal "First Last", @user.full_name
      end

      should "return `First Last` from first person when no current person" do
        Current.stubs(:person).returns(nil)
        @user.stubs(:people).returns([@person])

        assert_equal "First Last", @user.full_name
      end

      should "return empty string when no person exists" do
        Current.stubs(:person).returns(nil)
        @user.stubs(:people).returns([])

        assert_equal "", @user.full_name
      end
    end

    context "format is :last_first" do
      should "return `Last, First` from current person" do
        Current.stubs(:person).returns(@person)

        assert_equal "Last, First", @user.full_name(:last_first)
      end
    end

    context "format is unsupported" do
      should "delegate to person and raise ArgumentError" do
        Current.stubs(:person).returns(@person)

        assert_raises(ArgumentError) { @user.full_name(:foobar) }
      end
    end
  end

  context "#first_person_name" do
    should "return name from first person record" do
      organization = create(:organization)
      user = create(:user)
      create(:person, user: user, organization: organization, first_name: "John", last_name: "Doe")

      # Use the actual method instead of stubbing
      result = user.first_person_name
      assert_equal "John", result[:first_name]
      assert_equal "Doe", result[:last_name]
    end

    should "return empty strings when no person exists" do
      user = create(:user)

      result = user.first_person_name
      assert_equal "", result[:first_name]
      assert_equal "", result[:last_name]
    end
  end

  context "#name_initials" do
    should "return initials from current person" do
      organization = create(:organization)
      user = create(:user)
      person = create(:person, user: user, organization: organization, first_name: "John", last_name: "Doe")

      Current.stubs(:person).returns(person)

      assert_equal "JD", user.name_initials
    end

    should "return initials from first person when no current person" do
      organization = create(:organization)
      user = create(:user)
      person = create(:person, user: user, organization: organization, first_name: "Jane", last_name: "Smith")

      Current.stubs(:person).returns(nil)
      user.stubs(:people).returns([person])

      assert_equal "JS", user.name_initials
    end

    should "return empty string when no person exists" do
      user = create(:user)

      Current.stubs(:person).returns(nil)
      user.stubs(:people).returns([])

      assert_equal "", user.name_initials
    end
  end

  context "devise" do
    context "active_for_authentication?" do
      setup do
        @person = create(:person, :adopter)
        @org = @person.organization
        @user = @person.user
      end

      context "when Current.organization is present" do
        setup do
          Current.stubs(:organization).returns(@org)
          ActsAsTenant.stubs(:with_tenant).with(@org).yields
        end

        should "call active_for_devise?" do
          @user.expects(:active_for_devise?).once

          @user.active_for_authentication?
        end

        should "return false when person is deactivated in current org" do
          @person.stubs(:deactivated_in_org?).returns(true)
          @user.people.stubs(:first).returns(@person)

          assert_equal false, @user.send(:active_for_devise?)
        end

        should "return true when person is active in current org" do
          @person.stubs(:deactivated_in_org?).returns(false)
          @user.people.stubs(:first).returns(@person)

          assert_equal true, @user.send(:active_for_devise?)
        end

        should "return true when user has no person in current org" do
          user = create(:user)
          assert_equal true, user.send(:active_for_devise?)
        end
      end
    end

    context "inactive_message" do
      should "return :deactivated when active_for_devise? is false" do
        Current.stubs(:organization).returns(create(:organization))
        user = create(:user)

        user.expects(:active_for_devise?).returns(false)
        assert_equal :deactivated, user.inactive_message
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
