# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  # Configure additional authorization contexts here
  # (`user` is added by default).
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context
  authorize :user, allow_nil: true
  authorize :organization, optional: true

  # The Current.person is generally what we want to check for authorization.
  # User's can be in many org's but only have one Person per org. Permissions
  # are base on the active groups assigned to the person. Some public views check permissions
  # to conditionally display links. `allow_nil` lets use check without raising an error.
  # This authorization context must also be configured in the place where the authorization
  # is performed (e.g., controllers)
  authorize :person, allow_nil: true

  pre_check :verify_authenticated!
  pre_check :verify_tos_agreement!

  # Action Policy defaults https://actionpolicy.evilmartians.io/#/aliases?id=default-rule

  # default_rule :manage?
  # alias_rule :new?, to: :create?
  # def index?() = false
  # def create?() = false
  # def manage?() = false

  # Default authorized_scope; override for individual policies if necessary.
  relation_scope do |relation|
    relation.where(organization: Current.organization)
  end

  private

  # Define shared methods useful for most policies.

  def verify_record_organization!
    # if the record is an instance, we want to check that the record belongs to the same org as the person acting on it.
    if record.respond_to?(:organization_id)
      deny! unless record.organization_id == person.organization_id
    end
  end

  def permission?(name)
    return false unless person

    person.permission?(name)
  end

  def authenticated? = user.present?

  def unauthenticated? = !authenticated?

  def verify_authenticated!
    deny! if unauthenticated?
  end

  def verify_tos_agreement!
    deny!(:no_tos_accepted) unless user.tos_agreement?
  end
end
