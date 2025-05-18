require "test_helper"
require "action_policy/test_helper"

class Organizations::Staff::FaqsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = ActsAsTenant.current_tenant
    @faq = create(:faq)

    user = create(:person, :admin).user
    sign_in user
  end

  context "authorization" do
    include ActionPolicy::TestHelper

    context "new" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, Faq,
          with: Organizations::FaqPolicy
        ) do
          get new_staff_faq_url
        end
      end
    end

    context "create" do
      setup do
        @params = {
          faq: attributes_for(:faq)
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, Faq,
          with: Organizations::FaqPolicy
        ) do
          post staff_faqs_url, params: @params
        end
      end
    end

    context "index" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, Faq,
          with: Organizations::FaqPolicy
        ) do
          get staff_faqs_url
        end
      end

      should "have authorized scope" do
        assert_have_authorized_scope(
          type: :active_record_relation,
          with: Organizations::FaqPolicy
        ) do
          get staff_faqs_url
        end
      end
    end

    context "#show" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @faq, with: Organizations::FaqPolicy
        ) do
          get staff_faq_url(@faq)
        end
      end
    end

    context "#edit" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @faq,
          with: Organizations::FaqPolicy
        ) do
          get edit_staff_faq_url(@faq)
        end
      end
    end

    context "#update" do
      setup do
        @params = {
          faq: {
            question: "new question"
          }
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @faq,
          with: Organizations::FaqPolicy
        ) do
          patch staff_faq_url(@faq),
            params: @params
        end
      end
    end

    context "#destroy" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @faq,
          with: Organizations::FaqPolicy
        ) do
          delete staff_faq_url(@faq)
        end
      end
    end
  end

  teardown do
    :after_teardown
  end

  should "get index" do
    get staff_faqs_url
    assert_response :success
  end

  should "get new" do
    get new_staff_faq_url
    assert_response :success
  end

  context "#show" do
    should "get show" do
      get staff_faq_url(@faq)
      assert_response :success
    end
    should "show faq with turbo" do
      get staff_faq_url(@faq), as: :turbo_stream

      assert_response :success
      assert_turbo_stream action: "replace", target: @faq do
        assert_select "strong", text: "Q: #{@faq.question}"
      end
    end
  end

  context "POST #create" do
    should "create new faq" do
      assert_difference("@organization.faqs.count", 1) do
        post staff_faqs_path, params: {
          faq: {
            question: "New question?",
            answer: "New answer"
          }
        }
      end

      assert_response :redirect
      follow_redirect!
      assert_equal "FAQ was successfully created.", flash.notice
    end

    should "not create new default pet task with invalid or missing param" do
      assert_difference("@organization.faqs.count", 0) do
        post staff_faqs_path, params: {
          faq: {
            question: "",
            answer: "Answer without question"
          }
        }
        post staff_faqs_path, params: {
          faq: {
            question: "Question without answer",
            answer: ""
          }
        }
      end

      assert_template :new
    end
  end

  context "GET #edit" do
    should "visit edit page" do
      get edit_staff_faq_path(@faq)

      assert_response :success
      assert_select "h1", text: "Edit FAQ"
    end

    should "not visit edit page of inexistent task" do
      get edit_staff_faq_path(id: Faq.order(:id).last.id + 1)

      assert_response :redirect
      follow_redirect!
      assert_equal "FAQ not found.", flash.alert
    end

    should "edit faq with turbo" do
      get edit_staff_faq_url(@faq), as: :turbo_stream

      assert_response :success
      assert_turbo_stream action: "replace", target: @faq do
        assert_select "form"
      end
    end
  end

  context "PATCH #update" do
    should "update FAQ" do
      assert_changes "@faq.question" do
        patch staff_faq_path(@faq), params: {
          faq: {
            question: @faq.question + " new question"
          }
        }

        @faq.reload
      end

      assert_response :redirect
      follow_redirect!
      assert_equal "FAQ was successfully updated.", flash.notice
    end

    should "not update default pet task with invalid or missing param" do
      patch staff_faq_path(@faq), params: {
        faq: {
          question: ""
        }
      }

      assert_template :edit
    end

    should "update faq with turbo" do
      patch staff_faq_url(@faq), params: {
        faq: {
          question: "new question"
        }
      }, as: :turbo_stream

      assert_response :success
      assert_turbo_stream action: "replace", target: @faq do
        assert_select "strong", text: "Q: new question"
      end
    end

    should "render inline edit with turbo if error occurs" do
      patch staff_faq_path(@faq, format: :turbo_stream), params: {
        faq: {
          question: ""
        }
      }

      assert_turbo_stream action: "replace", target: @faq do
        assert_select "form"
      end
    end
  end

  context "DELETE #destroy" do
    should "destroy a FAQ" do
      assert_difference("@organization.faqs.count", -1) do
        delete staff_faq_path(@faq)
      end

      assert_response :redirect
      follow_redirect!
      assert_equal "FAQ was successfully deleted.", flash.notice
    end

    should "redirect with error for inexistent FAQ" do
      delete staff_faq_path(id: Faq.order(:id).last.id + 1)

      assert_response :redirect
      follow_redirect!
      assert_equal "FAQ not found.", flash.alert
    end

    should "delete faq with turbo" do
      delete staff_faq_url(@faq), as: :turbo_stream

      assert_response :success
      assert_turbo_stream action: "remove", target: @faq
    end
  end
end
