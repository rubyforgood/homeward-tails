require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::StaffControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = ActsAsTenant.current_tenant
    @staff = create(:admin)
    sign_in @staff
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#update_activation" do
      should "be authorized" do
        assert_authorized_to(
          :update_activation?, @staff, with: Organizations::UserPolicy
        ) do
          patch staff_staff_update_activation_url(@staff)
        end
      end
    end

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, User,
          context: {organization: @organization},
          with: Organizations::UserPolicy
        ) do
          get staff_staff_index_url
        end
      end

      context "when user is authorized" do
        setup do
          user = create(:super_admin)
          sign_in user
        end

        should "have authorized scope" do
          assert_have_authorized_scope(
            type: :active_record_relation, with: Organizations::UserPolicy
          ) do
            get staff_staff_index_url
          end
        end
      end
    end
  end

  test "update activation should respond with turbo_stream when toggled on staff page" do
    user = create(:super_admin)
    sign_in user

    patch staff_staff_update_activation_url(@staff), as: :turbo_stream

    assert_equal Mime[:turbo_stream], response.media_type
    assert_response :success
  end
end
