# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  # Configure additional authorization contexts here
  # (`user` is added by default).
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context
  authorize :user, allow_nil: true
  authorize :organization, optional: true

  pre_check :verify_authenticated!

  # Action Policy defaults https://actionpolicy.evilmartians.io/#/aliases?id=default-rule

  # default_rule :manage?
  # alias_rule :new?, to: :create?
  # def index?() = false
  # def create?() = false
  # def manage?() = false

  # Default authorized_scope; override for individual policies if necessary.
  relation_scope do |relation|
    relation.where(organization: user.organization)
  end

  private

  # Define shared methods useful for most policies.

  def organization
    @organization || record.organization
  end

  def verify_organization!
    deny! unless user.organization_id == organization.id
  end

  def verify_active_staff!
    deny! unless user.staff?(organization)
    deny! if user.deactivated?
  end

  def permission?(name)
    return false unless user

    user.permission?(name)
  end

  def authenticated? = user.present?

  def unauthenticated? = !authenticated?

  def verify_authenticated!
    deny! if unauthenticated?
  end
end
