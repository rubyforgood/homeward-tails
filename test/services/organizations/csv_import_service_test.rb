require "test_helper"
require "csv"

module Organizations
  class CsvImportServiceTest < ActiveSupport::TestCase
    setup do
      adopter = create(:adopter)
      Current.organization = adopter.organization

      @file = Tempfile.new(["test", ".csv"])
      @file.stubs(:content_type).returns("text/csv")

      headers = ["Timestamp", "First name", "Last name", "Email", "Address", "Phone number", *Faker::Lorem.questions]

      @data = [
        "2024-10-02 12:45:37.000000000 +0000",
        adopter.first_name,
        adopter.last_name,
        adopter.email,
        Faker::Address.full_address,
        Faker::PhoneNumber.phone_number,
        *Faker::Lorem.sentences
      ]

      @adopter = adopter

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

      assert_difference "FormSubmission.count" do
        assert_difference("FormAnswer.count", + 7) do
          Organizations::Importers::CsvImportService.new(@file).call
        end
      end
    end

    should "skip row if adopter with email does not exist" do
      @data[3] = "email@skip.com"
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end

      assert_no_difference "FormSubmission.count" do
        Organizations::Importers::CsvImportService.new(@file).call
      end
    end

    should "skip if row is already in database" do
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
        csv << @data
      end
      assert_difference "FormSubmission.count", 1 do
        Organizations::Importers::CsvImportService.new(@file).call
      end
    end

    should "return summary of import when successful" do
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end
      import = Organizations::Importers::CsvImportService.new(@file).call

      assert import.success?
      assert_equal 1, import.count
      assert import.errors.empty?
    end

    should "return errors" do
      @data[0] = "2024/13/27 10:24:05 AM AST"
      CSV.open(@file.path, "ab") do |csv|
        csv << @data
      end
      import = Organizations::Importers::CsvImportService.new(@file).call

      refute import.success?
      assert_equal "mon out of range", import.errors[0][1].message
    end

    should "validate file type" do
      file = Tempfile.new(["test", ".png"])
      file.stubs(:content_type).returns("image/png")
      import = Organizations::Importers::CsvImportService.new(file).call

      assert_equal "Invalid File Type: File type must be CSV", import.errors.first.message
    end

    should "validate empty file" do
      file = Tempfile.new(["test", ".csv"])
      file.stubs(:content_type).returns("text/csv")
      import = Organizations::Importers::CsvImportService.new(file).call

      assert_equal "File is empty", import.errors.first.message
    end

    should "validate email header" do
      file = Tempfile.new(["test", ".csv"])
      headers = ["Timestamp", "First name", "Last name", "Address", "Phone number", *Faker::Lorem.questions]
      CSV.open(file.path, "wb") do |csv|
        csv << headers
      end
      file.stubs(:content_type).returns("text/csv")
      import = Organizations::Importers::CsvImportService.new(file).call

      assert_equal 'The column header "Email" was not found in the attached csv', import.errors.first.message
    end

    should "validate Timestamp header" do
      file = Tempfile.new(["test", ".csv"])
      headers = ["Email", "First name", "Last name", "Address", "Phone number", *Faker::Lorem.questions]
      CSV.open(file.path, "wb") do |csv|
        csv << headers
      end
      file.stubs(:content_type).returns("text/csv")
      import = Organizations::Importers::CsvImportService.new(file).call

      assert_equal 'The column header "Timestamp" was not found in the attached csv', import.errors.first.message
    end
  end
end
