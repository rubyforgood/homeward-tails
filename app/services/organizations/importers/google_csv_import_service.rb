require "csv"

module Organizations
  module Importers
    class GoogleCsvImportService
      Status = Data.define(:success?, :count, :no_match, :errors)
      def initialize(file)
        @file = file
        @organization = Current.organization
        @count = 0
        @no_match = []
        @errors = []
      end

      def call
        catch(:halt_import) do
          validate_file

          CSV.foreach(@file.to_path, headers: true, skip_blanks: true).with_index(1) do |row, index|
            # Using Google Form headers
            email = row["Email"].downcase
            csv_timestamp = Time.parse(row["Timestamp"])

            person = Person.find_by(email:, organization: @organization)
            previously_matched_form_submission = FormSubmission.where(person:, csv_timestamp:)

            if person.nil?
              @no_match << [index, email]
            elsif previously_matched_form_submission.present?
              next
            else
              latest_form_submission = person.latest_form_submission
              ActiveRecord::Base.transaction do
                # This checks for the empty form submission that is added when a person is created
                if latest_form_submission.csv_timestamp.nil? && latest_form_submission.form_answers.empty?
                  latest_form_submission.update!(csv_timestamp:)
                  create_form_answers(latest_form_submission, row)
                else
                  # if the person submits a new/updated form,
                  # i.e. an additional row in the csv with the same email / different timestamp,
                  # a new form_submission will be created
                  create_form_answers(FormSubmission.create!(person:, csv_timestamp:), row)
                end
                @count += 1
              end
            end
          rescue => e
            @errors << [index, e]
          end
        end
        Status.new(@errors.empty?, @count, @no_match, @errors)
      end

      private

      def validate_file
        raise FileTypeError unless @file.content_type == "text/csv"
        raise EmailColumnError unless CSV.foreach(@file.to_path).first.include?("Email")
      rescue EmailColumnError, FileTypeError => e
        @errors << e
        throw :halt_import
      end

      def create_form_answers(form_submission, row)
        row.each do |col|
          next if col[0] == "Email" || col[0] == "Timestamp"

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

      class FileTypeError < StandardError
        def message
          "Invalid File Type: File type must be CSV"
        end
      end
    end
  end
end
