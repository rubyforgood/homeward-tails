require "test_helper"
require "action_policy/test_helper"

module Organizations
  module AdopterFosterer
    class FosteredPetsControllerTest < ActionDispatch::IntegrationTest
      context "authorization" do
        include ActionPolicy::TestHelper

        setup do
          @organization = ActsAsTenant.current_tenant
          @fosterer = create(:fosterer)
          sign_in @fosterer
        end

        context "#index" do
          should "be authorized" do
            get adopter_fosterer_fostered_pets_url
            assert_response :success
          end

          should "have authorized scope" do
            ActsAsTenant.with_tenant(@organization) do
              assert_have_authorized_scope(
                type: :active_record_relation,
                with: Organizations::AdopterFosterer::MatchPolicy
              ) do
                get adopter_fosterer_fostered_pets_url
              end
            end
          end

          should "return only foster matches for the person" do
            ActsAsTenant.with_tenant(@organization) do
              user_foster_match = create(:match, :foster, person: @fosterer.person, organization: @organization, start_date: Date.current, end_date: Date.current + 10.days)
              other_account_foster_match = create(:match, :foster, organization: @organization, start_date: Date.current, end_date: Date.current + 10.days)
              other_org_foster_match = create(:match, :foster, start_date: Date.current, end_date: Date.current + 10.days)

              get adopter_fosterer_fostered_pets_url

              assert_includes assigns(:fostered_pets), user_foster_match
              assert_not_includes assigns(:fostered_pets), other_account_foster_match
              assert_not_includes assigns(:fostered_pets), other_org_foster_match
            end
          end
        end
      end
    end
  end
end
