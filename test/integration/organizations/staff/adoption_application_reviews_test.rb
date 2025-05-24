require "test_helper"

class Organizations::Staff::AdoptionApplicationReviewsTest < ActionDispatch::IntegrationTest
  setup do
    @adopter = create(:person, :adopter)
    @awaiting_review_app = create(:adopter_application, status: :awaiting_review)
    @under_review_app = create(:adopter_application, status: :under_review)
    create(:adopter_application, :adoption_pending)
    create(:adopter_application, :withdrawn)
    create(:adopter_application, status: :successful_applicant)
    create(:adopter_application, status: :adoption_made)
    @custom_page = create(:custom_page, organization: ActsAsTenant.current_tenant)

    # Setup for show view tests
    @form_submission = create(:form_submission, person: @adopter)
    @form_answers = create_list(:form_answer, 3, form_submission: @form_submission)
    @adopter_application = create(:adopter_application, person: @adopter)
  end

  context "non-staff" do
    should "not see any applications" do
      user = create(:person, :adopter).user
      sign_in user

      get staff_adoption_application_reviews_path

      assert_response :redirect
      follow_redirect!
      follow_redirect!
      assert_equal I18n.t("errors.authorization_error"), flash[:alert]
    end
  end

  context "active staff" do
    setup do
      sign_in create(:person, :admin).user
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
      patch staff_note_path,
        params: {
          note: {
            content: "some notes",
            notable_id: @under_review_app.id,
            notable_type: @under_review_app.class.name
          },
          context: "default"
        },
        headers: {"HTTP_REFERER" => "example.com"}

      assert_response :redirect
      follow_redirect!

      @under_review_app.reload
      assert_equal("some notes", @under_review_app.content)
    end

    context "deactivated staff" do
      setup do
        sign_in create(:person, :admin, deactivated: true).user
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
