require "test_helper"

class Organizations::QuestionPolicyTest < ActiveSupport::TestCase
  include PetRescue::PolicyAssertions

  context "context only action" do
    setup do
      @organization = ActsAsTenant.current_tenant
      @policy = -> { Organizations::QuestionPolicy.new(Question, user: @user, organization: @organization) }
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
      end

      context "when user is nil" do
        setup do
          @user = nil
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is adopter" do
        setup do
          @user = create(:adopter)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is fosterer" do
        setup do
          @user = create(:fosterer)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is deactivated staff" do
        setup do
          @user = create(:staff, :deactivated)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is staff admin" do
        setup do
          @user = create(:staff_admin)
        end

        should "return true" do
          assert_equal @action.call, true
        end
      end
    end

    context "#index?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :index?, :manage?
      end
    end

    context "#new?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :new?, :manage?
      end
    end

    context "#create?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :create?, :manage?
      end
    end
  end

  context "existing record action" do
    setup do
      @question = create(:question)
      @policy = -> { Organizations::QuestionPolicy.new(@question, user: @user) }
    end

    context "#manage?" do
      setup do
        @action = -> { @policy.call.apply(:manage?) }
      end

      context "when user is nil" do
        setup do
          @user = nil
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is adopter" do
        setup do
          @user = create(:adopter)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is fosterer" do
        setup do
          @user = create(:fosterer)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is deactivated staff" do
        setup do
          @user = create(:staff, :deactivated)
        end

        should "return false" do
          assert_equal @action.call, false
        end
      end

      context "when user is staff admin" do
        setup do
          @user = create(:staff_admin)
        end

        should "return true" do
          assert_equal @action.call, true
        end
      end
    end

    context "#show?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :show?, :manage?
      end
    end

    context "#edit?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :edit?, :manage?
      end
    end

    context "#update?" do
      should "be an alias to :manage?" do
        assert_alias_rule @policy.call, :update?, :manage?
      end
    end
  end
end
