require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::ManageFostersControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper
    context "context only action" do
      setup do
        @adopter = create(:person, :adopter).user
        sign_in @adopter
      end

      context "#new" do
        should "be authorized" do
          assert_authorized_to(
            :manage?, Match,
            with: Organizations::MatchPolicy
          ) do
            get new_staff_manage_foster_url
          end
        end
      end

      context "#create" do
        should "be authorized" do
          assert_authorized_to(
            :manage?, Match,
            with: Organizations::MatchPolicy
          ) do
            post staff_manage_fosters_url
          end
        end
      end

      context "#index" do
        should "be authorized" do
          assert_authorized_to(
            :manage?, Match,
            with: Organizations::MatchPolicy
          ) do
            get staff_manage_fosters_url
          end
        end

        context "when user is authorized" do
          setup do
            user = create(:person, :super_admin).user
            sign_in user
          end

          should "have authorized scope" do
            assert_have_authorized_scope(
              type: :active_record_relation,
              with: Organizations::MatchPolicy
            ) do
              get staff_manage_fosters_url
            end
          end
        end
      end
    end

    context "existing record actions" do
      setup do
        fosterer = create(:person, :fosterer)
        @foster = create(:foster, person: fosterer)
        sign_in fosterer.user
      end

      context "#edit" do
        should "be authorized" do
          assert_authorized_to(
            :manage?, @foster,
            with: Organizations::MatchPolicy
          ) do
            get edit_staff_manage_foster_url(@foster)
          end
        end
      end

      context "#update" do
        should "be authorized" do
          assert_authorized_to(
            :manage?, @foster,
            with: Organizations::MatchPolicy
          ) do
            patch staff_manage_foster_url(@foster)
          end
        end
      end

      context "#destroy" do
        should "be authorized" do
          assert_authorized_to(
            :manage?, @foster,
            with: Organizations::MatchPolicy
          ) do
            delete staff_manage_foster_url(@foster)
          end
        end
      end
    end
  end
end
