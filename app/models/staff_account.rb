# == Schema Information
#
# Table name: staff_accounts
#
#  id              :bigint           not null, primary key
#  deactivated_at  :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_staff_accounts_on_organization_id  (organization_id)
#  index_staff_accounts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class StaffAccount < ApplicationRecord
  acts_as_tenant(:organization)
  belongs_to :user

  def email
    user.email.to_s
  end

  def deactivate
    update(deactivated_at: Time.now) unless deactivated_at
  end

  def activate
    update(deactivated_at: nil) if deactivated_at
  end

  def deactivated?
    !!deactivated_at
  end
end
