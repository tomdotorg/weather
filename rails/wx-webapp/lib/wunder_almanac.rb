require 'logger'
require 'wunderground'
require 'json'

class WunderAlmanacManager < WunderBase
  log = Logger.new(STDOUT)
  log.level = Logger::INFO

  def get_almanac
    d = Time.now.at_midnight
    a = Climate.find_or_initialize_by_location_and_month_and_day(@location, d.month, d.day)
    if a.new_record? or a.updated_at < d
      c = @api.almanac_for(@location)["almanac"]
      a.avg_high_temp = c["temp_high"]["normal"]["F"].to_i
      a.avg_low_temp = c["temp_low"]["normal"]["F"].to_i
      if c["temp_high"]["record"]
        a.record_high_temp = c["temp_high"]["record"]["F"].to_i
        a.record_high_temp_year = c["temp_high"]["recordyear"].to_i
        a.record_low_temp = c["temp_low"]["record"]["F"].to_i
        a.record_low_temp_year = c["temp_low"]["recordyear"].to_i
        a.mean_temp = (a.avg_high_temp + a.avg_low_temp) / 2
      end
      a.touch
      a.save!
    end
    return a
  end
end
