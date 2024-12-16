# frozen_string_literal: true

class DashboardPageComponent < ViewComponent::Base
  attr_reader :crumb, :crumb_options

  def initialize(crumb: nil, crumb_options: [])
    @crumb = crumb
    @crumb_options = crumb_options
  end

  renders_one :header_title
  renders_one :header_subtitle
  renders_one :action
  renders_many :nav_tabs, "NavTabComponent"
  renders_one :body

  private

  def before_render
    breadcrumb crumb, *crumb_options if crumb
  end
end
