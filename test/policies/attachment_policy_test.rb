require "test_helper"

# See https://actionpolicy.evilmartians.io/#/testing?id=testing-policies
class ActiveStorage::AttachmentPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "existing record action" do
    setup do
      @pet = create(:pet, :with_image)
      @attachment = @pet.images.last
      @policy = -> { ActiveStorage::AttachmentPolicy.new(@attachment, person: @person, user: @person&.user) }
    end

    context "#purge?" do
      setup do
        @action = -> { @policy.call.apply(:purge?) }
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

      context "when user is active staff" do
        setup do
          @person = create(:person, :admin)
        end

        context "when attachment's record's organization matches user's" do
          should "return true" do
            assert_equal true, @action.call
          end
        end

        context "when attachment's record's organization does not match user's" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @pet = create(:pet, :with_image)
            end

            should "return false" do
              should "return false" do
                assert_equal false, @action.call
              end
            end
          end
        end
      end

      context "when user is deactivated staff" do
        setup do
          @person = create(:person, :admin, deactivated: true)
        end

        should "return false" do
          assert_equal false, @action.call
        end
      end

      context "when user is staff admin" do
        setup do
          @person = create(:person, :super_admin)
        end

        context "when attachment's record's organization matches user's" do
          should "return true" do
            assert_equal true, @action.call
          end
        end

        context "when attachment's record's organization does not match user's" do
          setup do
            ActsAsTenant.with_tenant(create(:organization)) do
              @pet = create(:pet, :with_image)
            end

            should "return false" do
              should "return false" do
                assert_equal false, @action.call
              end
            end
          end
        end
      end
    end
  end
end
