class AdoptablePetPolicy < ApplicationPolicy
  skip_pre_check :verify_authenticated!, only: %i[show?]

  relation_scope do |relation|
    relation.where(published: true).where.missing(:match)
  end

  def show?
    permission?(:manage_pets) || published?
  end

  private

  def published?
    record.published?
  end
end