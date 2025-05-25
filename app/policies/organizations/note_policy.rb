module Organizations
  class NotePolicy < ApplicationPolicy
    pre_check :verify_record_organization!

    def update?
      permission?(:manage_notes)
    end
  end
end
