require "test_helper"

class TabsComponentTest < ViewComponent::TestCase
  should "render nav tabs and content panes for each tab" do
    tabs = {
      tab_1: {label: "Tab 1", src: "/fake/tab1", partial: nil},
      tab_2: {label: "Tab 2", src: "/fake/tab2", partial: nil, active: true},
      tab_3: {label: "Tab 3", src: nil, partial: "fake/partial", locals: {foo: "bar"}}
    }

    TabsComponent.any_instance.stubs(:render).returns("<!-- stubbed partial -->")

    render_inline(TabsComponent.new(tabs: tabs))

    # Navigation tab buttons
    assert_selector("nav div#nav-tab button", count: 3)
    assert_selector("button#nav-tab_1", text: "Tab 1")
    assert_selector("button#nav-tab_2.active", text: "Tab 2")
    assert_selector("button#nav-tab_3", text: "Tab 3")

    # Tab panes
    assert_selector("div#nav-tabContent.tab-content .tab-pane", count: 3)
    assert_selector("turbo-frame#tab_1[src='/fake/tab1']")
    assert_selector("turbo-frame#tab_2[src='/fake/tab2'].show.active")
    assert_selector("turbo-frame#tab_3:not([src])", text: /stubbed partial/)
  end

  should "mark first tab active if none are marked active" do
    tabs = {
      first: {label: "First", src: "/fake/first"},
      second: {label: "Second", src: "/fake/second"}
    }

    render_inline(TabsComponent.new(tabs: tabs))

    assert_selector("button#nav-first.active")
    assert_selector("turbo-frame#first.show.active")
  end
end
