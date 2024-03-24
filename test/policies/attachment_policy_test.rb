require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class ActiveStorage::AttachmentPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "existing record action" do
    setup do
      @pet = create(:pet, :with_image)
      @attachment = @pet.images.last
      @policy = -> { ActiveStorage::AttachmentPolicy.new(@attachment, user: @user) }
    end

    context "#purge?" do
      setup do
        @action = -> { @policy.call.apply(:purge?) }
      end

      context "when user is nil" do
        setup do
          @user = nil
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is adopter" do
        setup do
          @user = create(:adopter)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is active staff" do
        setup do
          @user = create(:staff)
        end

        context "when attachment's record's organization matches user's" do
          should "return true" do
            assert_equal @action.call, true
          end
        end

        context "when attachment's record's organization does not match user's" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @pet = create(:pet, :with_image)
            end

            should "return false" do
              should "return false" do
                assert_equal @action.call, false
              end
            end
          end
        end
      end

      context "when user is deactivated staff" do
        setup do
          @user = create(:staff, :deactivated)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is staff admin" do
        setup do
          @user = create(:staff_admin)
        end

        context "when attachment's record's organization matches user's" do
          should "return true" do
            assert_equal @action.call, true
          end
        end

        context "when attachment's record's organization does not match user's" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @pet = create(:pet, :with_image)
            end

            should "return false" do
              should "return false" do
                assert_equal @action.call, false
              end
            end
          end
        end
      end
    end
  end
end
