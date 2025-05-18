require "application_system_test_case"

class DashboardTest < ApplicationSystemTestCase
  setup do
    @user = create(:person, :admin).user
    @organization = Current.organization
    @pets = create_list(:pet, 3, organization: @organization)

    @pets.each do |pet|
      create_list(:task, 2, pet: pet, completed: false, due_date: nil)
      create_list(:task, 1, pet: pet, completed: false, due_date: 2.days.ago)
    end

    sign_in @user
    visit staff_dashboard_index_path
  end

  test "viewing incomplete tasks" do
    click_link "Incomplete"
    assert_selector "table"
    assert_text "Incomplete Pet Tasks"
    within "table" do
      @pets.each do |pet|
        assert_text pet.name
        assert_text "2"
      end
    end
  end

  test "viewing overdue tasks" do
    click_link "Overdue"
    assert_selector "table"
    assert_text "Overdue Pet Tasks"

    within "table" do
      @pets.each do |pet|
        assert_text pet.name
        assert_text "1"
      end
    end
  end
end
