module Organizations
  class NotePolicy < ApplicationPolicy
    pre_check :verify_organization!
    pre_check :verify_active_staff!

    def update?
      permission?(:manage_notes)
    end
  end
end
