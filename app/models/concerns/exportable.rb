require "csv"

module Exportable
  extend ActiveSupport::Concern

  class_methods do
    def to_csv(columns = column_names)
      CSV.generate(headers: true) do |csv|
        csv << columns

        all.find_each do |record|
          csv << columns.map { |attr| record.send(attr) }
        end
      end
    end
  end
end
