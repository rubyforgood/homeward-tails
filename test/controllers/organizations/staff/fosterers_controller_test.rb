require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::FosterersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = ActsAsTenant.current_tenant
    @admin = create(:admin)
    @fosterer = create(:person)
    sign_in @admin
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, Person,
          context: {organization: @organization},
          with: Organizations::PersonPolicy
        ) do
          get staff_fosterers_url
        end
      end

      context "when user is authorized" do
        setup do
          user = create(:super_admin)
          sign_in user
        end

        should "have authorized scope" do
          assert_have_authorized_scope(
            type: :active_record_relation,
            with: Organizations::PersonPolicy
          ) do
            get staff_fosterers_url
          end
        end
      end
    end
  end

  context "#edit" do
    should "render the edit form" do
      get edit_staff_fosterer_path(@fosterer)

      assert_response :success
    end
  end

  context "#update" do
    should "update fosterer" do
      patch staff_fosterer_url(@fosterer), params: {person: {phone_number: "+12015557890"}}

      assert_response :redirect
      assert_equal "+12015557890", @fosterer.reload.phone_number
    end

    should "fail update" do
      patch staff_fosterer_url(@fosterer), params: {person: {first_name: ""}}

      assert_response :unprocessable_entity
    end
  end
end
