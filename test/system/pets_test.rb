require "application_system_test_case"

class PetsTest < ApplicationSystemTestCase
  setup do
    user = create(:person, :admin).user
    sign_in user
    @pets = create_list(:pet, 5)
  end

  test "displays table view on large screens" do
    resize_window_to_large
    visit staff_pets_path

    assert_selector ".d-xl-block", visible: true
    assert_no_selector ".d-xl-none", visible: true
  end

  test "displays card view on small screens" do
    resize_window_to_small
    visit staff_pets_path

    assert_selector ".d-xl-none", visible: true
    assert_no_selector ".d-xl-block", visible: true
  end

  private

  def resize_window_to_large
    page.driver.browser.resize(width: 1200, height: 800)
  end

  def resize_window_to_small
    page.driver.browser.resize(width: 600, height: 800)
  end
end
