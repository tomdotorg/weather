require "test/unit"
require 'astro'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_timeframes
    civil_riseset_today = Astro.get_civil_riseset
    civil_riseset_tomorrow = Astro.get_civil_riseset(Time.now + 1.day)
    civil_riseset_week = Astro.get_civil_riseset(Time.now + 1.week)
    civil_riseset_two_weeks = Astro.get_civil_riseset(Time.now + 2.weeks)
    civil_riseset_month = Astro.get_civil_riseset(Time.now + 1.month)
    civil_riseset_two_months = Astro.get_civil_riseset(Time.now + 2.months)
    civil_riseset_three_months = Astro.get_civil_riseset(Time.now + 3.months)
    civil_riseset_six_months = Astro.get_civil_riseset(Time.now + 6.months)
  end
end