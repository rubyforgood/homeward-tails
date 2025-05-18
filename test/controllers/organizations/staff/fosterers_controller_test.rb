require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::FosterersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = ActsAsTenant.current_tenant
    @admin = create(:person, :admin).user
    @fosterer = create(:person)
    sign_in @admin
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :index?, Person,
          with: Organizations::PersonPolicy
        ) do
          get staff_fosterers_url
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
            with: Organizations::PersonPolicy
          ) do
            get staff_fosterers_url
          end
        end

        should "filter by email" do
          create(:person, :fosterer, email: "bob.cat@gmail.com")
          create(:person, :fosterer, email: "sally.cat@gmail.com")

          get staff_fosterers_url, params: {q: {email_cont: "sally.cat@gmail.com"}}
          assert_response :success

          assert_equal 1, assigns[:fosterer_accounts].count
          assert_not_includes assigns[:fosterer_accounts].map { |fosterer| fosterer.email }, "bob.cat@gmail.com"
        end

        should "filter by name" do
          create(:person, :fosterer, first_name: "Bob", last_name: "Cat")
          create(:person, :fosterer, first_name: "Sally", last_name: "Cat")
          create(:person, :fosterer, first_name: "Sally", last_name: "Smith")

          get staff_fosterers_url, params: {q: {first_name_or_last_name_cont: "Sally"}}
          assert_response :success

          assert_equal 2, assigns[:fosterer_accounts].count
          assert_not_includes assigns[:fosterer_accounts].map { |fosterer| fosterer.first_name }, "Bob"
        end

        should "generate CSV with fosterers' emails" do
          fosterer = create(:person, :fosterer)

          get staff_fosterers_url, params: {format: :csv}
          assert_response :success
          assert_includes response.header["Content-Type"], "text/csv"
          assert_includes response.body, fosterer.email
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
