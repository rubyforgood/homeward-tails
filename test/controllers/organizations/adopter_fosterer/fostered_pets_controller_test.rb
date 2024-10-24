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

          should "return only current foster matches for the person" do
            ActsAsTenant.with_tenant(@organization) do
              completed_foster = create(:pet, :completed_foster)
              current_foster = create(:pet, :current_foster, foster_person: @fosterer.person)
              future_foster = create(:pet, :future_foster)

              get adopter_fosterer_fostered_pets_url

              assert_includes assigns(:fostered_pets), current_foster.matches.first
              assert_not_includes assigns(:fostered_pets), completed_foster.matches.first
              assert_not_includes assigns(:fostered_pets), future_foster.matches.first
            end
          end
        end
      end
    end
  end
end
