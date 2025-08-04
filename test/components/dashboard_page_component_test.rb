# frozen_string_literal: true

require "test_helper"

class DashboardPageComponentTest < ViewComponent::TestCase
  setup do
    @component = DashboardPageComponent.new
  end

  context "with slots" do
    setup do
      @component = DashboardPageComponent.new.tap do |c|
        c.with_header_title { "Title" }
        c.with_header_subtitle { "subtitle" }
        c.with_action { "action" }
        c.with_nav_tabs([
          {url: "/a", text: "A"},
          {url: "/b", text: "B"},
          {url: "/c", text: "C"}
        ])
        c.with_body { "body" }
      end
      render_inline(@component)
    end

    should "render page header title" do
      assert_selector("h2.section-heading", text: "Title")
    end

    should "render page header subtitle" do
      assert_selector("p.section-subheading", text: "subtitle")
    end

    should "render page action" do
      assert_text("action")
    end

    should "render page nav tabs" do
      assert_selector("li.nav-item", text: "A")
      assert_selector("li.nav-item", text: "B")
      assert_selector("li.nav-item", text: "C")
    end

    should "render page body" do
      assert_text("body")
    end
  end

  context "before render" do
    context "when crumb is passed" do
      setup do
        @crumb = :brulee
        @component = DashboardPageComponent.new(crumb: @crumb)
      end

      should "call breadcrumb with crumb" do
        view_context = mock('view_context')
        view_context.expects(:breadcrumb).with(@crumb)
        view_context.stubs(:breadcrumbs).returns('')
        ViewComponent::Base.any_instance.stubs(:helpers).returns(view_context)
        render_inline(@component)
      end
    end

    context "when crumb is passed with options" do
      setup do
        @crumb = :brulee
        @options = [:option]
        @component = DashboardPageComponent.new(crumb: @crumb, crumb_options: @options)
      end

      should "call breadcrumb with crumb and options" do
        view_context = mock('view_context')
        view_context.expects(:breadcrumb).with(@crumb, *@options)
        view_context.stubs(:breadcrumbs).returns('')
        ViewComponent::Base.any_instance.stubs(:helpers).returns(view_context)
        render_inline(@component)
      end
    end

    context "when no crumb is passed" do
      setup do
        @component = DashboardPageComponent.new
      end

      should "not call breadcrumb" do
        view_context = mock('view_context')
        view_context.expects(:breadcrumb).never
        view_context.stubs(:breadcrumbs).returns('')
        ViewComponent::Base.any_instance.stubs(:helpers).returns(view_context)
        render_inline(@component)
      end
    end
  end
end
