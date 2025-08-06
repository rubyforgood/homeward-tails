# frozen_string_literal: true

class GroupStatusComponent < ApplicationComponent
  def initialize(person:, group_names:)
    @person = person
    @group_names = Array(group_names).map(&:to_sym)

    @group_map = @person.groups.index_by { |g| g.name.to_sym }
    @deactivated_map = @person.person_groups.index_by(&:group_id)
  end

  def group
    @group_names.map { |name| @group_map[name] }.compact.first
  end

  def group_name
    group&.name&.titleize
  end

  def deactivated?
    @deactivated_map[group.id]&.deactivated_at.present?
  end

  def status
    if group.nil?
      :missing
    elsif deactivated?
      :deactivated
    else
      :active
    end
  end
end
