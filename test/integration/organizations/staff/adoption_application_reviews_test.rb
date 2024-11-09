require "test_helper"

class Organizations::Staff::AdoptionApplicationReviewsTest < ActionDispatch::IntegrationTest
  setup do
    form_submission = create(:form_submission)
    @awaiting_review_app = create(:adopter_application, status: :awaiting_review, form_submission: form_submission)
    @under_review_app = create(:adopter_application, status: :under_review, form_submission: form_submission)
    create(:adopter_application, :adoption_pending, form_submission: form_submission)
    create(:adopter_application, :withdrawn, form_submission: form_submission)
    create(:adopter_application, status: :successful_applicant, form_submission: form_submission)
    create(:adopter_application, status: :adoption_made, form_submission: form_submission)
    @custom_page = create(:custom_page, organization: ActsAsTenant.current_tenant)
  end

  context "non-staff" do
    should "not see any applications" do
      @user = create(:user)
      sign_in @user

      get staff_adoption_application_reviews_path

      assert_response :redirect
      follow_redirect!
      follow_redirect!
      assert_equal I18n.t("errors.authorization_error"), flash[:alert]
    end
  end

  context "active staff" do
    setup do
      sign_in create(:admin)
    end

    should "see all applications" do
      get staff_adoption_application_reviews_path

      assert_response :success
      AdopterApplication.first(5).each { |application| verify_application_elements application }
    end

    should "be able to change the application status" do
      patch staff_adoption_application_review_path(@awaiting_review_app.id),
        params: {adopter_application: {status: :under_review}},
        headers: {"HTTP_REFERER" => "example.com"}

      assert_response :redirect
      follow_redirect!
      @awaiting_review_app.reload
      assert_equal "under_review", @awaiting_review_app.status
    end

    should "be able to add a note to an application" do
      patch staff_adoption_application_review_path(@under_review_app.id),
        params: {adopter_application: {notes: "some notes"}},
        headers: {"HTTP_REFERER" => "example.com"}

      assert_response :redirect
      follow_redirect!

      @under_review_app.reload
      assert_equal("some notes", @under_review_app.notes)
    end

    context "deactivated staff" do
      setup do
        sign_in create(:admin, :deactivated)
      end

      should_eventually "not see any applications" do
        get staff_adoption_application_reviews_path

        assert_response :redirect
        follow_redirect!
        follow_redirect!
        assert_equal "Unauthorized action.", flash[:alert]
      end
    end
  end

  def verify_application_elements(application)
    assert_select "tr[id='table_row_adopter_application_#{application.id}']" do
      assert_select "button", text: application.status.titleize
    end
  end
end
