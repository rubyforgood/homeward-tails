require "test_helper"

class Organizations::LikePolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "#index?" do
    setup do
      @policy = -> { Organizations::LikePolicy.new(Like, person: @person, user: @person&.user) }
      @action = -> { @policy.call.apply(:index?) }
    end

    context "when user is nil" do
      setup do
        @person = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @person = create(:person, :adopter)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is fosterer" do
      setup do
        @person = create(:person, :fosterer)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff" do
      setup do
        @person = create(:person, :admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end

  context "#create?" do
    setup do
      @policy = -> {
        Organizations::LikePolicy.new(@pet,
          person: @person,
          user: @person&.user)
      }
      @action = -> { @policy.call.apply(:create?) }
    end

    context "with pet belonging to organization" do
      setup do
        @pet = create(:pet)
      end
      context "when user is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is staff" do
        setup do
          @person = create(:person, :admin)
        end

        should "return false" do
          assert_equal false, @action.call
        end

        should "return true when also an adopter" do
          @person.add_group(:adopter)

          assert_equal true, @action.call
        end
      end
    end
    context "with pet belonging to different organization" do
      setup do
        @person = create(:person, :adopter)
        ActsAsTenant.with_tenant(create(:organization)) do
          @pet = create(:pet)
        end
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end

  context "#destroy?" do
    context "when like belongs to person" do
      setup do
        @like = -> { build(:like, person: @person) }
        @policy = -> {
          Organizations::LikePolicy.new(@like.call,
            person: @person,
            user: @person&.user)
        }
        @action = -> { @policy.call.apply(:destroy?) }
      end

      context "when user is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is staff" do
        setup do
          @person = create(:person, :admin)
        end

        should "return false" do
          assert_equal false, @action.call
        end

        should "return true when also an adopter" do
          @person.add_group(:adopter)

          assert_equal true, @action.call
        end
      end
    end
    context "when like does not belong to person" do
      setup do
        @like = build(:like)
        @person = create(:person, :adopter)
        @policy = -> {
          Organizations::LikePolicy.new(@like,
            person: @person,
            user: @person&.user)
        }
        @action = -> { @policy.call.apply(:destroy?) }
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end
end
