require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::PersonPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "context only action" do
    setup do
      @policy = -> {
        Organizations::PersonPolicy.new(Person, person: @person, user: @person&.user)
      }
    end

    context "#index?" do
      setup do
        @action = -> { @policy.call.apply(:index?) }
      end

      context "when person is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is fosterer" do
        setup do
          @person = create(:person, :fosterer)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is admin" do
        setup do
          @person = create(:person, :admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when person is super admin" do
        setup do
          @person = create(:person, :super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end
    end
  end

  context "existing record action" do
    setup do
      @record = create(:person)
      @policy = -> {
        Organizations::PersonPolicy.new(@record, person: @person, user: @person&.user)
      }
    end
    context "#edit?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :edit?, :manage?
      end
    end

    context "#update?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :update?, :manage?
      end
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
      end

      context "when person is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return false" do
          assert_equal false, @action.call
        end

        context "when record is the person's" do
          should "return true" do
            @record = @person

            assert_equal true, @action.call
          end
        end
      end

      context "when person is fosterer" do
        setup do
          @person = create(:person, :fosterer)
        end

        should "return false" do
          assert_equal false, @action.call
        end

        context "when record is the person's" do
          should "return true" do
            @record = @person

            assert_equal true, @action.call
          end
        end
      end

      context "when person is admin" do
        setup do
          @person = create(:person, :admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @person = create(:person, :super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end

        context "when person is deactivated staff" do
          setup do
            @person = create(:person, :admin, deactivated: true)
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when record belongs to a different organization" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @record = create(:person)
            end
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end
      end
    end

    context "#show?" do
      setup do
        @action = -> { @policy.call.apply(:show?) }
      end

      context "when person is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when perosn is fosterer" do
        setup do
          @person = create(:person, :fosterer)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is admin" do
        setup do
          @person = create(:person, :admin)
        end

        context "when person belongs to a different organization" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @person = create(:person)
            end
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when person belongs to user's organization" do
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end

      context "when person is super admin" do
        setup do
          @person = create(:person, :super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end
      end

      context "when person is deactivated staff" do
        setup do
          @person = create(:person, :admin, deactivated: true)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end

    context "#edit_name?" do
      setup do
        @action = -> { @policy.call.apply(:edit_name?) }
      end

      context "when person is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when perosn is fosterer" do
        setup do
          @person = create(:person, :fosterer)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is admin" do
        setup do
          @person = create(:person, :admin)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when person is super admin" do
        setup do
          @person = create(:person, :super_admin)
        end

        context "when person belongs to a different organization" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @person = create(:person)
            end
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end

        context "when person belongs to user's organization" do
          should "return true" do
            assert_equal true, @action.call
          end
        end
      end

      context "when person is deactivated staff" do
        setup do
          @person = create(:person, :admin, deactivated: true)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
