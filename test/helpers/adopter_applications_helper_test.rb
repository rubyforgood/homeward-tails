# frozen_string_literal: true

require "test_helper"

class AdopterApplicationsHelperTest < ActionView::TestCase
  context "#link_to_application?" do
    setup do
        @staff_user = create(:admin)
        @adopter_user = create(:adopter)
        Current.organization = @staff_user.organization
    end

    context "status is adoption_made" do
        setup do
            @application_adoption_made = create(:adopter_application, status: :adoption_made)
        end

        should "return true if current user is staff in current organization" do
            assert(link_to_application?(@application_adoption_made, @staff_user))
        end

        should "return false if current user is not staff in current organization" do
            assert_not(link_to_application?(@application_adoption_made, @adopter_user))
        end
    end

    context "status is anything but adoption_made" do
        setup do
            @application = create(:adopter_application)
        end

        should "return true if staff" do
            assert(link_to_application?(@application, @staff_user))
        end

        should "return true if adopter" do
            assert(link_to_application?(@application, @adopter_user))
        end

    end
  end
end
