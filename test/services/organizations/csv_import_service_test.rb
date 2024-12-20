require "test_helper"
require "csv"

module Organizations
  class CsvImportServiceTest < ActiveSupport::TestCase
    setup do
      @adopter = create(:adopter)
      Current.organization = @adopter.organization

      @file = Tempfile.new(["test", ".csv"])

      headers = ["Timestamp", "First name", "Last name", "Email", "Address", "Phone number", *Faker::Lorem.questions]

      @data = [
        "2024-10-02 12:45:37.000000000 +0000",
        @adopter.first_name,
        @adopter.last_name,
        @adopter.email,
        Faker::Address.full_address,
        Faker::PhoneNumber.phone_number,
        *Faker::Lorem.sentences
      ]

      CSV.open(@file.path, "wb") do |csv|
        csv << headers
      end
    end

    teardown do
      @file.unlink
    end

    should "add row information to database if adopter exists" do
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end
      blob = ActiveStorage::Blob.create_and_upload!(
        io: @file.open,
        filename: "file.csv"
      )
      assert_difference "FormSubmission.count" do
        assert_difference("FormAnswer.count", + 7) do
          Organizations::Importers::CsvImportService.new(blob, @adopter.id).call
        end
      end
    end

    should "skip row if adopter with email does not exist" do
      @data[3] = "email@skip.com"
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end

      blob = ActiveStorage::Blob.create_and_upload!(
        io: @file.open,
        filename: "file.csv"
      )
      assert_no_difference "FormSubmission.count" do
        Organizations::Importers::CsvImportService.new(blob, @adopter.id).call
      end
    end

    should "skip if row is already in database" do
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
        csv << @data
      end

      blob = ActiveStorage::Blob.create_and_upload!(
        io: @file.open,
        filename: "file.csv"
      )
      assert_difference "FormSubmission.count", 1 do
        Organizations::Importers::CsvImportService.new(blob, @adopter.id).call
      end
    end

    should "return successful scan broadcast" do
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end
      blob = ActiveStorage::Blob.create_and_upload!(
        io: @file.open,
        filename: "file.csv"
      )
      service = Organizations::Importers::CsvImportService.new(blob, @adopter.id)
      service.call
      errors = service.instance_variable_get(:@errors)

      turbo_stream = capture_turbo_stream_broadcasts ["csv_import", @adopter]

      assert_equal "File successfully scanned", turbo_stream.first.at_css(".alert-heading").text.strip
      assert errors.empty?
    end

    should "return errors for malformed data" do
      @data[0] = "2024/13/27 10:24:05 AM AST"
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end
      blob = ActiveStorage::Blob.create_and_upload!(
        io: @file.open,
        filename: "file.csv"
      )
      service = Organizations::Importers::CsvImportService.new(blob, @adopter.id)
      service.call
      errors = service.instance_variable_get(:@errors)

      turbo_stream = capture_turbo_stream_broadcasts ["csv_import", @adopter]

      assert_equal "File scanned: 1 error(s) present", turbo_stream.first.at_css(".alert-heading").text.strip
      assert_equal "mon out of range", errors.first[1].message
    end

    should "validate file type" do
      blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test/fixtures/files/logo.png")),
        filename: "file.png",
        content_type: "image/png"
      )
      service = Organizations::Importers::CsvImportService.new(blob, @adopter.id)
      service.call
      errors = service.instance_variable_get(:@errors)

      assert_turbo_stream_broadcasts ["csv_import", @adopter]
      turbo_stream = capture_turbo_stream_broadcasts ["csv_import", @adopter]
      assert_equal "File scanned: 1 error(s) present", turbo_stream.first.at_css(".alert-heading").text.strip
      assert_equal "Invalid File Type: File type must be CSV", errors.first[1].message
    end

    should "validate email header" do
      file = Tempfile.new(["test", ".csv"])
      headers = ["Timestamp", "First name", "Last name",
        "Address", "Phone number", *Faker::Lorem.questions]
      CSV.open(file.path, "wb") do |csv|
        csv << headers
      end
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file.open,
        filename: "file.csv"
      )
      service = Organizations::Importers::CsvImportService.new(blob, @adopter.id)
      service.call
      errors = service.instance_variable_get(:@errors)

      assert_turbo_stream_broadcasts ["csv_import", @adopter]
      turbo_stream = capture_turbo_stream_broadcasts ["csv_import", @adopter]
      assert_equal "File scanned: 1 error(s) present", turbo_stream.first.at_css(".alert-heading").text.strip
      assert_equal  'The column header "Email" was not found in the attached csv', errors.first[1].message
    end

    should "validate Timestamp header" do
      file = Tempfile.new(["test", ".csv"])
      headers = ["Email", "First name", "Last name",
        "Address", "Phone number", *Faker::Lorem.questions]
      CSV.open(file.path, "wb") do |csv|
        csv << headers
      end
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file.open,
        filename: "file.csv"
      )
      service = Organizations::Importers::CsvImportService.new(blob, @adopter.id)
      service.call
      errors = service.instance_variable_get(:@errors)

      assert_turbo_stream_broadcasts ["csv_import", @adopter]
      turbo_stream = capture_turbo_stream_broadcasts ["csv_import", @adopter]
      assert_equal "File scanned: 1 error(s) present", turbo_stream.first.at_css(".alert-heading").text.strip
      assert_equal  'The column header "Timestamp" was not found in the attached csv', errors.first[1].message    end
  end
end
