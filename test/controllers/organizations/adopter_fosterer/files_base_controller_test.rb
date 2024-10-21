require "test_helper"
require "action_policy/test_helper"

module Organizations
  module AdopterFosterer
    class FilesBaseControllerTest < ActionDispatch::IntegrationTest
      context "authorization" do
        include ActionPolicy::TestHelper

        setup do
          @organization = ActsAsTenant.current_tenant
          @adopter = create(:adopter)
          sign_in @adopter
          @pet = create(:pet)
        end

        context "#index" do
          should "be authorized" do
            get adopter_fosterer_adopted_pet_files_url(@pet, pet_id: @pet.id)
            assert_response :success
          end

          should "assign the requested pet" do
            get adopter_fosterer_adopted_pet_files_url(@pet, pet_id: @pet.id)
            assert_equal @pet, assigns(:pet)
          end
        end
      end
    end
  end
end
