require "test_helper"
require "action_policy/test_helper"

class Organizations::AdopterFosterer::AdoptedPetsControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant
      @adopter = create(:person, :adopter)
      sign_in @adopter.user
    end

    context "#index" do
      should "be authorized" do
        get adopter_fosterer_adopted_pets_url
        assert_response :success
      end

      should "have authorized scope" do
        ActsAsTenant.with_tenant(@organization) do
          assert_have_authorized_scope(
            type: :active_record_relation,
            with: Organizations::AdopterFosterer::MatchPolicy, context: {page: "adopted_pets"}
          ) do
            get adopter_fosterer_adopted_pets_url
          end
        end
      end

      should "return only adoption matches for the person" do
        ActsAsTenant.with_tenant(@organization) do
          user_adoption_match = create(:match, :adoption, person: @adopter, organization: @organization)
          other_account_adoption_match = create(:match, :adoption, organization: @organization)
          other_org_adoption_match = create(:match, :adoption)

          get adopter_fosterer_adopted_pets_url

          assert_includes assigns(:adopted_pets), user_adoption_match
          assert_not_includes assigns(:adopted_pets), other_account_adoption_match
          assert_not_includes assigns(:adopted_pets), other_org_adoption_match
        end
      end
    end
  end
end
