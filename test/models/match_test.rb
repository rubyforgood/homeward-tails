require "test_helper"

class MatchTest < ActiveSupport::TestCase
  setup do
    @match = build_stubbed(:match)
  end

  context "associations" do
    should belong_to(:pet)
    should belong_to(:person)
  end

  context "validations" do
    should define_enum_for(:match_type)
  end

  context "#withdraw_application" do
    setup do
      @application = mock("adopter_application")
    end

    should "send #withdraw to application" do
      @match.expects(:adopter_application).returns(@application)
      @application.expects(:withdraw)

      @match.withdraw_application
    end
  end

  context "#retire_applications" do
    setup do
      @application_class = mock("AdopterApplication")
    end

    should "send #retire_applications with pet_id to application_class" do
      @application_class.expects(:retire_applications).with(pet_id: @match.pet_id)

      @match.retire_applications(application_class: @application_class)
    end
  end

  context "scopes" do
    context ".ordered_by_status_and_date" do
      should "return matches ordered by status first, start date second, end date third" do
        current = create(:match, start_date: 1.day.ago, end_date: 1.day.from_now) # current
        upcoming = create(:match, start_date: 3.days.from_now, end_date: 5.days.from_now) # upcoming
        completed_earlier = create(:match, start_date: 5.days.ago, end_date: 2.days.ago) # complete
        upcoming_earlier = create(:match, start_date: 2.days.from_now, end_date: 4.days.from_now) # upcoming (earlier than match2)
        completed = create(:match, start_date: 1.day.ago, end_date: 1.day.ago) # complete (same end_date as match3)

        # Fetch ordered results
        ordered_matches = Match.ordered_by_status_and_date

        # Assert the order of the matches by their ids
        assert_equal [current.id, upcoming_earlier.id, upcoming.id, completed_earlier.id, completed.id], ordered_matches.pluck(:id)
      end
    end
  end

  context "status" do
    context "when end date is less than current time" do
      setup do
        @start_date = Time.current - 10.day
        @end_date = Time.current - 1.day
        @match = create(:match, start_date: @start_date, end_date: @end_date)
      end

      should "return :complete" do
        assert_equal :complete, @match.status
      end
    end

    context "when start date is greater than current time" do
      setup do
        @start_date = Time.current + 1.day
        @end_date = Time.current + 3.day
        @match = create(:match, start_date: @start_date, end_date: @end_date)
      end

      should "return :upcoming" do
        assert_equal :upcoming, @match.status
      end
    end

    context "when current time is between start and end date" do
      setup do
        @start_date = Time.current - 1.day
        @end_date = Time.current + 1.day
        @match = create(:match, start_date: @start_date, end_date: @end_date)
      end

      should "return :current" do
        assert_equal :current, @match.status
      end
    end

    context "when start_date is nil" do
      setup do
        @match = create(:match, start_date: nil, end_date: nil)
      end

      should "return :not_applicable" do
        assert_equal :not_applicable, @match.status
      end
    end

    context "when end_date is nil" do
      setup do
        @match = create(:match, start_date: nil, end_date: nil)
      end

      should "return :not_applicable" do
        assert_equal :not_applicable, @match.status
      end
    end
  end
end
