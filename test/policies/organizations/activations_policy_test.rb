require "test_helper"

class Organizations::ActivationsPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "when record being updated is staff" do
    context "#update?" do
      context "when group is admin" do
        setup do
          # record being updated
          @record = create(:person, :admin)
          group = @record.groups.find_by(name: :admin)
          # Organizations::ActivationsPolicy.any_instance.stubs(:verify_record_organization!).returns(true)

          @action = -> {
            policy = Organizations::ActivationsPolicy.new(@record,
              person: @person,
              group: group)
            policy.update?
          }
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

          should "return false" do
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

          context "when person is self" do
            setup do
              @record = @person
            end

            should "return false" do
              assert_equal false, @action.call
            end
          end
        end
      end
      context "when group is super_admin" do
        setup do
          @record = create(:person, :super_admin)
          group = @record.groups.find_by(name: :super_admin)

          @action = -> {
            policy = Organizations::ActivationsPolicy.new(@record,
              person: @person,
              group: group)
            policy.update?
          }
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

  context "when record being updated is fosterer" do
    context "#update?" do
      setup do
        @record = create(:person, :fosterer)
        group = @record.groups.find_by(name: :fosterer)

        @action = -> {
          policy = Organizations::ActivationsPolicy.new(@record,
            person: @person,
            group: group)
          policy.update?
        }
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

  context "when record being updated is adopter" do
    context "#update?" do
      setup do
        @record = create(:person, :adopter)
        group = @record.groups.find_by(name: :adopter)

        @action = -> {
          policy = Organizations::ActivationsPolicy.new(@record,
            person: @person,
            group: group)
          policy.update?
        }
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

  context "when group organization does not match the record organization" do
    context "#update?" do
      setup do
        @record = create(:person, :admin)

        @action = -> {
          policy = Organizations::ActivationsPolicy.new(@record,
            person: @person,
            group: OpenStruct.new(organization_id: @record.organization_id + 1))
          policy.update?
        }
      end
      context "when person is staff" do
        setup do
          @person = create(:person, :super_admin)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end
    end
  end
end
