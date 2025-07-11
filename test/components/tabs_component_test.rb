require "test_helper"

class TabsComponentTest < ViewComponent::TestCase
  should "render nav tabs and content panes for each tab" do
    tabs = [
      {id: "tab-1", label: "Tab 1", src: "/fake/tab1", partial: nil},
      {id: "tab-2", label: "Tab 2", src: "/fake/tab2", partial: nil, active: true},
      {id: "tab-3", label: "Tab 3", src: nil, partial: "fake/partial", locals: {foo: "bar"}}
    ]

    TabsComponent.any_instance.stubs(:render).returns("<!-- stubbed partial -->")

    render_inline(TabsComponent.new(tabs: tabs))

    # Navigation tab buttons
    assert_selector("nav div#nav-tab button", count: 3)
    assert_selector("button#nav-tab-1", text: "Tab 1")
    assert_selector("button#nav-tab-2.active", text: "Tab 2")
    assert_selector("button#nav-tab-3", text: "Tab 3")

    # Tab panes
    assert_selector("div#nav-tabContent.tab-content .tab-pane", count: 3)
    assert_selector("turbo-frame#tab-1[src='/fake/tab1']")
    assert_selector("turbo-frame#tab-2[src='/fake/tab2'].show.active")
    assert_selector("turbo-frame#tab-3:not([src])", text: /stubbed partial/)
  end

  should "mark first tab active if none are marked active" do
    tabs = [
      {id: "first", label: "First", src: "/fake/first"},
      {id: "second", label: "Second", src: "/fake/second"}
    ]

    render_inline(TabsComponent.new(tabs: tabs))

    assert_selector("button#nav-first.active")
    assert_selector("turbo-frame#first.show.active")
  end
end
