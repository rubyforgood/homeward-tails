module PetRansackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      %w[name sex species breed placement_type application_paused published]
    end

    def ransackable_associations(auth_object = nil)
      ["adopter_applications", "matches"]
    end

    def ransackable_scopes(auth_object = nil)
      [:ransack_adopted, :ransack_birth_date]
    end

    # Using string values to get around ransack bug: https://github.com/activerecord-hackery/ransack/issues/1375
    def ransack_adopted(adoption_state)
      (adoption_state == "adopted") ? adopted : unadopted
    end

    def ransack_birth_date(date)
      start_date, end_date = date.split("/")

      if start_date != "none" && end_date != "none"
        where("birth_date >= ? AND birth_date <= ?", start_date, end_date)
      elsif start_date == "none" && end_date != "none"
        where("birth_date <= ?", end_date)
      elsif start_date != "none" && end_date == "none"
        where("birth_date >= ?", start_date)
      end
    end
  end
end
