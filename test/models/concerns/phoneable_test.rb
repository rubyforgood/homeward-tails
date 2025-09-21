require "test_helper"

class PhoneableTest < ActiveSupport::TestCase
  class DummyPhoneable
    extend ActiveModel::Callbacks

    define_model_callbacks :save

    include Phoneable

    attr_accessor :phone_number

    def save
      run_callbacks :save do
        # dummy save action, don't actually do anything
      end
    end
  end

  setup do
    @phoneable = DummyPhoneable.new
  end

  context "#formatted_phone_number" do
    should "return properly formatted phone number" do
      @phoneable.phone_number = "+12508168212"
      assert_equal "(250) 816-8212", @phoneable.formatted_phone_number
    end

    should "return properly formatted international phone number" do
      @phoneable.phone_number = "+442071838750"
      assert_equal "+44 20 7183 8750", @phoneable.formatted_phone_number
    end

    should "return original phone number if invalid" do
      @phoneable.phone_number = "123"
      assert_equal "123", @phoneable.formatted_phone_number
    end
  end

  context "before_save callback" do
    should "normalize phone number" do
      @phoneable.phone_number = "(250) 816-8212"
      @phoneable.save
      assert_equal "+12508168212", @phoneable.phone_number
    end

    should "not normalize nil phone number" do
      @phoneable.phone_number = nil
      @phoneable.save
      assert_nil @phoneable.phone_number
    end
  end
end
