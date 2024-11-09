require "test_helper"
require "action_policy/test_helper"

module Organizations
  module AdopterFosterer
    module AdoptedPets
      class TasksBaseControllerTest < ActionDispatch::IntegrationTest
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
              get adopter_fosterer_adopted_pet_tasks_url(@pet, pet_id: @pet.id)
              assert_response :success
            end

            should "assign the requested pet" do
              get adopter_fosterer_adopted_pet_tasks_url(@pet, pet_id: @pet.id)
              assert_equal @pet, assigns(:pet)
            end

            should "assign incomplete tasks" do
              incomplete_task = create(:task, pet: @pet, completed: false)
              create(:task, pet: @pet, completed: true)

              get adopter_fosterer_adopted_pet_tasks_url(@pet, pet_id: @pet.id)
              assert_includes assigns(:tasks), incomplete_task
              refute_includes assigns(:tasks), Task.where(completed: true)
            end
          end
        end
      end
    end
  end
end
