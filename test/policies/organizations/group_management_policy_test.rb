require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class Organizations::PersonPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "existing record action" do
    context "when group is adopter" do
      setup do
        @record = create(:person)
        @policy = -> {
          Organizations::GroupManagementPolicy.new(@record, person: @person, user: @person&.user, group: :adopter)
        }
      end
      context "#add_group?" do
        setup do
          @action = -> { @policy.call.apply(:add_group?) }
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
    end

    context "when group is fosterer" do
      setup do
        @record = create(:person)
        @policy = -> {
          Organizations::GroupManagementPolicy.new(@record, person: @person, user: @person&.user, group: :fosterer)
        }
      end
      context "#add_group?" do
        setup do
          @action = -> { @policy.call.apply(:add_group?) }
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

    context "when group is admin" do
      setup do
        @record = create(:person)
        @policy = -> {
          Organizations::GroupManagementPolicy.new(@record, person: @person, user: @person&.user, group: :admin)
        }
      end
      context "#add_group?" do
        setup do
          @action = -> { @policy.call.apply(:add_group?) }
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
            assert_equal false, @action.call
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

    context "when group is super_admin" do
      setup do
        @record = create(:person)
        @policy = -> {
          Organizations::GroupManagementPolicy.new(@record, person: @person, user: @person&.user, group: :super_admin)
        }
      end
      context "#add_group?" do
        setup do
          @action = -> { @policy.call.apply(:add_group?) }
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
            assert_equal false, @action.call
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
  end
end
