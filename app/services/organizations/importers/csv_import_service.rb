require "csv"

module Organizations
  module Importers
    class CsvImportService
      Status = Data.define(:success?, :count, :no_match, :errors)
      def initialize(file, organization)
        @file = file
        @organization = organization
        @count = 0
        @no_match = []
        @errors = []
      end

      def call
        catch(:halt_import) do
          @file.download do |data|
            validate_file(data)
            CSV.parse(data, headers: true, skip_blanks: true).each_with_index do |row, index|
              # Header may be different depending on which form applicaiton was used(e.g. google forms) or how it was created(User creates form with "Email Address")
              email = row[@email_header].downcase
              # Google forms uses "Timestamp", other services may use a different header
              csv_timestamp = Time.parse(row["Timestamp"]) if row["Timestamp"].present?

              person = Person.find_by(email:, organization: @organization)
              previously_matched_form_submission = FormSubmission.where(person:, csv_timestamp:)

              if person.nil?
                @no_match << [index + 2, email]
              elsif previously_matched_form_submission.present?
                next
              else
                ActiveRecord::Base.transaction do
                  create_form_answers(FormSubmission.create!(person:, csv_timestamp:), row)
                  @count += 1
                end
              end
            rescue => e
              @errors << [index + 2, e]
            end
          end
        end
        Status.new(@errors.empty?, @count, @no_match, @errors)
      end

      private

      def validate_file(data)
        raise FileTypeError unless @file.content_type == "text/csv"
        first_row = CSV.new(data).shift
        raise FileEmptyError if first_row.nil?

        raise TimestampColumnError unless first_row.include?("Timestamp")

        email_headers = ["Email", "email", "Email Address", "email address"]
        email_headers.each do |e|
          @email_header = e if first_row.include?(e)
        end
        raise EmailColumnError unless @email_header
      rescue FileTypeError, FileEmptyError, TimestampColumnError, EmailColumnError => e
        @errors << e
        throw :halt_import
      end

      def create_form_answers(form_submission, row)
        row.each do |col|
          next if col[0] == @email_header || col[0] == "Timestamp"

          answer = col[1].nil? ? "" : col[1]
          FormAnswer.create!(
            form_submission:,
            question_snapshot: col[0],
            value: answer
          )
        end
      end

      class EmailColumnError < StandardError
        def message
          'The column header "Email" was not found in the attached csv'
        end
      end

      class TimestampColumnError < StandardError
        def message
          'The column header "Timestamp" was not found in the attached csv'
        end
      end

      class FileTypeError < StandardError
        def message
          "Invalid File Type: File type must be CSV"
        end
      end

      class FileEmptyError < StandardError
        def message
          "File is empty"
        end
      end
    end
  end
end
