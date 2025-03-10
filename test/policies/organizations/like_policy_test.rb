require "test_helper"

class Organizations::LikePolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "#index?" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @policy = -> { Organizations::LikePolicy.new(Like, user: @user, organization: @organization) }
      @action = -> { @policy.call.apply(:index?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @user = create(:adopter)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is fosterer" do
      setup do
        @user = create(:fosterer)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is staff" do
      setup do
        @user = create(:admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end
  end

  context "#create?" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @pet = create(:pet)
      @user = nil # Default user, can be overridden in nested contexts
      @policy = -> {
        Organizations::LikePolicy.new(Like,
          user: @user,
          organization: @organization,
          pet: @pet)
      }
      @action = -> { @policy.call.apply(:create?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @user = create(:adopter)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is staff" do
      setup do
        @user = create(:admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "with pet belonging to different organization" do
      setup do
        @organization2 = create(:organization)
        ActsAsTenant.with_tenant(@organization2) do
          @pet2 = create(:pet)
        end

        @policy = -> {
          Organizations::LikePolicy.new(Like,
            user: @user,
            organization: @organization,
            pet: @pet2)
        }
        @action = -> { @policy.call.apply(:create?) }
      end

      context "when pet does not belong to same org as adopter" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @user = create(:adopter)
          end
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when pet does not belong to same org as fosterer" do
        setup do
          @user = create(:fosterer)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end

  context "#destroy?" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @pet = create(:pet)
      @policy = -> {
        Organizations::LikePolicy.new(Like,
          user: @user,
          organization: @organization,
          pet: @pet)
      }
      @action = -> { @policy.call.apply(:destroy?) }
    end

    context "when user is nil" do
      setup do
        @user = nil
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "when user is adopter" do
      setup do
        @user = create(:adopter)
      end

      should "return true" do
        assert_equal true, @action.call
      end
    end

    context "when user is staff" do
      setup do
        @user = create(:admin)
      end

      should "return false" do
        assert_equal false, @action.call
      end
    end

    context "with pet belonging to different organization" do
      setup do
        @organization2 = create(:organization)
        ActsAsTenant.with_tenant(@organization2) do
          @pet2 = create(:pet)
        end

        @policy = -> {
          Organizations::LikePolicy.new(Like,
            user: @user,
            organization: @organization,
            pet: @pet2)
        }
        @action = -> { @policy.call.apply(:destroy?) }
      end

      context "when pet does not belong to same org as adopter" do
        setup do
          ActsAsTenant.with_tenant(create(:organization)) do
            @user = create(:adopter)
          end
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when pet does not belong to same org as fosterer" do
        setup do
          @user = create(:fosterer)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
