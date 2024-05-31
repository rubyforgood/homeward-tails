class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # This method is used to translate the enum values for i18n.
  def human_enum_name(enum)
    enum_i18n_key = enum.to_s
    value = send(enum)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_i18n_key}.#{value}")
  end
end
