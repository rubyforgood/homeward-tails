require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::MatchesControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      user = create(:person, :admin).user
      sign_in user
    end

    context "create" do
      setup do
        @organization = ActsAsTenant.current_tenant

        pet = create(:pet)
        person = create(:person)
        @params = {
          match: {
            pet_id: pet.id,
            person_id: person.id,
            match_type: :adoption
          }
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, Match,
          with: Organizations::MatchPolicy
        ) do
          post staff_matches_url, params: @params
        end
      end
    end

    context "#destroy" do
      setup do
        @match = create(:match, match_type: :adoption)
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @match,
          with: Organizations::MatchPolicy
        ) do
          delete staff_match_url(@match)
        end
      end
    end
  end
end
