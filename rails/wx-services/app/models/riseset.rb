class Riseset < ActiveRecord::Base
  def self.riseset(location, date)
    r = Riseset.find_by_location_and_month_and_day(location,
            date.localtime.month, date.localtime.day)
    rise = Time.gm(date.year, date.month, date.day, r.rise.hour, r.rise.min)
    set = Time.gm(date.year, date.month, (r.set.hour < r.rise.hour) ? date.day + 1 : date.day, r.set.hour, r.set.min)
    t = { :rise => rise, :set => set, :daylight => daylight(rise, set) }
    return t
  end

  # a very conservative measurement of light and dark. when in doubt, it's light.
  def self.dark?(location, date)
    date = date.localtime
    r = Riseset.riseset(location, date)
    #find_by_location_and_month_and_day(AppConfig.climate_location, date.month, date.day)
    return ((date < r[:rise] - 1.hour) or (date >= r[:set] + 1.hour))
  end

  # send it in in localtime to avoid logic around UTC
  # TODO - have this handle end times that are the next day
  # (only a problem if time is a time only and not a date/time type)

  def self.daylight(start_time, end_time)
    if end_time < start_time
      raise ArgumentError, 'end is earlier than start'
    end

    interval = end_time - start_time
    hours = (interval / SECONDS_IN_AN_HOUR).to_i
    mins = ((interval % SECONDS_IN_AN_HOUR) / 60).to_i
    tmp = Time.now
    return Time.gm(tmp.year, tmp.month, tmp.day, hours, mins)
  end
end
#t = Time.gm(Time.now.year, Time.now.month, Time.now.day, r[:set].hour, r[:set].min).localtime