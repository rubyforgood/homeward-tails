require "test_helper"

class PersonTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:user).optional
  end

  context "validations" do
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:email)
    should_not validate_presence_of(:phone_number)
  end

  context "associations" do
    should have_many(:form_submissions).dependent(:destroy)
    should have_many(:form_answers).through(:form_submissions)
    should have_many(:person_groups)
    should have_many(:groups).through(:person_groups)
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
        assert_includes subject.errors[:avatar], "file size must be less than 1 MB (current size is 5 MB)"
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

  context "delegate" do
    context "activation" do
      should delegate_method(:activate!).to(:activation)
      should delegate_method(:deactivate!).to(:activation)
    end

    context "group_member" do
      should delegate_method(:add_group).to(:group_member)
      should delegate_method(:active_in_group?).to(:group_member)
      should delegate_method(:deactivated_in_org?).to(:group_member)
    end

    context "staff" do
      should delegate_method(:staff?).to(:staff)

      should delegate_method(:active?).to(:staff).with_prefix
      should delegate_method(:current_group).to(:staff).with_prefix
      should delegate_method(:change_group).to(:staff).with_prefix
    end
  end

  context "active_staff" do
    setup do
      @active_admin = create(:person, :admin)
      @active_super_admin = create(:person, :super_admin)
      @deactivated_staff = create(:person, :admin, deactivated: true)
      @adopter = create(:person, :adopter)
      @fosterer = create(:person, :fosterer)
      @result = Person.active_staff
    end

    should "return active staff" do
      assert_includes @result, @active_admin
      assert_includes @result, @active_super_admin
    end

    should "not return deactivated staff" do
      refute_includes @result, @deactivated_staff
    end

    should "not return non staff" do
      refute_includes @result, @adopter
    end
  end

  def load_file(file_name)
    File.open Rails.root.join("test/fixtures/files", file_name)
  end
end
