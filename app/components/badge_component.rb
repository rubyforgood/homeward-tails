class BadgeComponent < ApplicationComponent
  param :label, Types::String
  option :when, Types::Bool, as: :condition, default: -> { true }
  option :class, Types::String, as: :css, default: -> { "badge" }

  def render? = condition
end
