require "application_system_test_case"

class ChecklistTemplateItemsTest < ApplicationSystemTestCase
  test "visiting the index" do
    create(:checklist_template_item)

    visit checklist_template_items_url

    assert_selector "h1", text: "Checklist template items"
  end

  test "should create checklist template item" do
    checklist_template_item = create(:checklist_template_item)

    visit checklist_template_items_url
    click_on "New checklist template item"

    select checklist_template_item.checklist_template.name, from: "Checklist template"
    fill_in "Description", with: checklist_template_item.description
    fill_in "Expected duration days", with: checklist_template_item.expected_duration_days
    fill_in "Name", with: checklist_template_item.name
    check "Required" if checklist_template_item.required
    click_on "Create Checklist template item"

    assert_text "Checklist template item was successfully created"
    click_on "Back"
  end

  test "should update Checklist template item" do
    checklist_template_item = create(:checklist_template_item)

    visit checklist_template_item_url(checklist_template_item)
    click_on "Edit this checklist template item", match: :first

    select checklist_template_item.checklist_template.name, from: "Checklist template"
    fill_in "Description", with: checklist_template_item.description
    fill_in "Expected duration days", with: checklist_template_item.expected_duration_days
    fill_in "Name", with: checklist_template_item.name
    check "Required" if checklist_template_item.required
    click_on "Update Checklist template item"

    assert_text "Checklist template item was successfully updated"
    click_on "Back"
  end

  test "should destroy Checklist template item" do
    checklist_template_item = create(:checklist_template_item)

    visit checklist_template_item_url(checklist_template_item)
    click_on "Destroy this checklist template item", match: :first

    assert_text "Checklist template item was successfully destroyed"
  end
end
