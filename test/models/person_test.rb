require "test_helper"

class PersonTest < ActiveSupport::TestCase
  context "associations" do
    should have_one(:user).dependent(:destroy)
  end

  context "validations" do
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:email)
    should_not validate_presence_of(:phone)
  end

  context "associations" do
    should have_many(:form_submissions).dependent(:destroy)
    should have_many(:form_answers).through(:form_submissions)
  end

  context "database validations" do
    subject { create(:person, organization: create(:organization)) }

    # FIXME `shoulda-matchers` is throwing an error here:
    # NoMethodError: undefined method `keys' for an instance of ActiveModel::Errors
    #
    # should validate_uniqueness_of(:email)
    #   .case_insensitive
    #   .scoped_to(:organization_id)
  end

  context "#avatar" do
    should "attach an avatar" do
      file = load_file("test.png")

      assert_nothing_raised do
        subject.avatar.attach(io: file, filename: "test.png")
      end
    end

    context "validations" do
      should "error if the avatar is too big" do
        file = load_file("test.png")
        file.stubs(:size).returns(5.megabytes)

        subject.avatar.attach(io: file, filename: "test.png")

        refute subject.valid?
        assert_includes subject.errors[:avatar], "size must be between 10kb and 1Mb"
      end

      should "error if the avatar is too small" do
        file = load_file("test.png")
        file.stubs(:size).returns(5.kilobytes)

        subject.avatar.attach(io: file, filename: "test.png")

        refute subject.valid?
        assert_includes subject.errors[:avatar], "size must be between 10kb and 1Mb"
      end

      should "error if the avatar is not an image" do
        file = load_file("blank.pdf")

        subject.avatar.attach(io: file, filename: "blank.pdf")

        refute subject.valid?
        assert_includes subject.errors[:avatar], "must be PNG or JPEG"
      end
    end
  end

  context "#full_name" do
    context "format is :default" do
      should "return `First Last`" do
        person = build(:user, first_name: "First", last_name: "Last")

        assert_equal "First Last", person.full_name
      end
    end

    context "format is :default" do
      should "return `First Last`" do
        person = build(:user, first_name: "First", last_name: "Last")

        assert_equal "First Last", person.full_name(:default)
      end
    end

    context "format is :last_first" do
      should "return `Last, First`" do
        person = build(:user, first_name: "First", last_name: "Last")

        assert_equal "Last, First", person.full_name(:last_first)
      end
    end

    context "format is unsupported" do
      should "raise ArgumentError" do
        person = build(:user, first_name: "First", last_name: "Last")

        assert_raises(ArgumentError) { person.full_name(:foobar) }
      end
    end
  end

  context "factories" do
    should "generate a valid person" do
      assert build(:person).valid?
    end
  end

  def load_file(file_name)
    File.open Rails.root.join("test/fixtures/files", file_name)
  end
end
