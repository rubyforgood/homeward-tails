# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  context "#organization_home_path" do
    should "return the correct path with the organization slug" do
      organization = create(:organization)

      assert_equal home_index_path(script_name: "/#{organization.slug}"), organization_home_path(organization)
      assert_match(/#{organization.slug}/, organization_home_path(organization))
    end
  end

  context "#default_country" do
    should "return organization's first country" do
      organization = create(:organization, :with_location)

      assert_equal organization.locations.first.country, default_country(organization)
    end

    context "when organization has no location" do
      should "return empty string" do
        organization = create(:organization)

        assert_equal "", default_country(organization)
      end
    end
  end
end
