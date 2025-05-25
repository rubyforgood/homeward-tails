require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::DashboardControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      user = create(:person, :admin).user
      sign_in user
    end

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, :dashboard,
          with: Organizations::DashboardPolicy
        ) do
          get staff_dashboard_index_url
        end
      end
    end

    context "#incomplete_tasks" do
      should "be authorized" do
        assert_authorized_to(
          :pets_with_incomplete_tasks?, :dashboard,
          with: Organizations::DashboardPolicy
        ) do
          get pets_with_incomplete_tasks_staff_dashboard_index_url, headers: {"Turbo-Frame" => "tasks-frame"}
        end
      end

      should "return turbo_stream response" do
        get pets_with_incomplete_tasks_staff_dashboard_index_url, headers: {"Turbo-Frame" => "tasks-frame"}
        assert_response :success
        assert_match "tasks-frame", response.body
      end
    end

    context "#overdue_tasks" do
      should "be authorized" do
        assert_authorized_to(
          :pets_with_overdue_tasks?, :dashboard,
          with: Organizations::DashboardPolicy
        ) do
          get pets_with_overdue_tasks_staff_dashboard_index_url, headers: {"Turbo-Frame" => "tasks-frame"}
        end
      end

      should "return turbo_stream response" do
        get pets_with_overdue_tasks_staff_dashboard_index_url, headers: {"Turbo-Frame" => "tasks-frame"}
        assert_response :success
        assert_match "tasks-frame", response.body
      end
    end
  end
end
