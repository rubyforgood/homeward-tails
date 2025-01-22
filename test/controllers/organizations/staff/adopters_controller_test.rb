require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::AdoptersControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant

      user = create(:admin)
      sign_in user
    end

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, Person,
          context: {organization: @organization},
          with: Organizations::PersonPolicy
        ) do
          get staff_adopters_url
        end
      end

      should "have authorized scope" do
        assert_have_authorized_scope(
          type: :active_record_relation, with: Organizations::PersonPolicy
        ) do
          get staff_adopters_url
        end
      end

      should "filter by email" do
        create(:adopter, email: "bob.cat@gmail.com")
        create(:adopter, email: "sally.cat@gmail.com")

        get staff_adopters_url, params: {q: {email_cont: "sally.cat@gmail.com"}}
        assert_response :success

        assert_equal 1, assigns[:adopter_accounts].count
        assert_not_includes assigns[:adopter_accounts].map { |adopter| adopter.email }, "bob.cat@gmail.com"
      end

      should "filter by name" do
        create(:adopter, first_name: "Bob", last_name: "Cat")
        create(:adopter, first_name: "Sally", last_name: "Cat")
        create(:adopter, first_name: "Sally", last_name: "Smith")

        get staff_adopters_url, params: {q: {first_name_or_last_name_cont: "Sally"}}
        assert_response :success

        assert_equal 2, assigns[:adopter_accounts].count
        assert_not_includes assigns[:adopter_accounts].map { |adopter| adopter.first_name }, "Bob"
      end
    end
  end
end
