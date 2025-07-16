# frozen_string_literal: true

class TabsComponent < ApplicationComponent
  attr_reader :tabs

  def initialize(tabs:)
    @tabs = tabs
  end
end
