require "test_helper"

class Organizations::ActivationsPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  setup do
    @policy = -> { Organizations::ActivationsPolicy.new(@person_being_updated, person: @person, user: @person&.user, group: @group) }
  end

  context "when resource being updated is admin" do
    context "#update?" do
      setup do
        @person_being_updated = create(:person, :admin)
        @group = @person_being_updated.groups.find_by(name: :admin)
        @action = -> { @policy.call.apply(:update?) }
      end

      context "when user is nil" do
        setup do
          @person = nil
        end

        should "return false" do
          assert_equal false, @policy.call.apply(:update?)
        end
      end

      context "when user is adopter" do
        setup do
          @person = create(:person, :adopter)
        end

        should "return false" do
          assert_equal false, @action.call
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

      context "when user is admin" do
        setup do
          @person = create(:person, :admin)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is super admin" do
        setup do
          @person = create(:person, :super_admin)
        end

        should "return true" do
          assert_equal true, @action.call
        end

        context "when staff is self" do
          setup do
            @person_being_updated = @person
          end

          should "return false" do
            assert_equal false, @action.call
          end
        end
      end
    end
  end

  context "when resource being updated is fosterer" do
    context "#update?" do
      setup do
        @person_being_updated = create(:person, :fosterer)
        @group = @person_being_updated.groups.find_by(name: :fosterer)
        @action = -> { @policy.call.apply(:update?) }
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

        should "return false" do
          assert_equal false, @action.call
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

      context "when user is admin" do
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
      end
    end
  end

  context "when resource being updated is adopter" do
    context "#update?" do
      setup do
        @person_being_updated = create(:person, :adopter)
        @group = @person_being_updated.groups.find_by(name: :adopter)
        @action = -> { @policy.call.apply(:update?) }
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

        should "return false" do
          assert_equal false, @action.call
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

      context "when user is admin" do
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
      end
    end
  end
end
