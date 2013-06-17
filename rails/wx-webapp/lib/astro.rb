require 'solareventcalculator'

class Astro

  SECONDS_IN_AN_HOUR = 60 * 60

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

  def self.get_calc(date = Time.now.to_date)
    SolarEventCalculator.new(date.to_date,
                             BigDecimal.new(AppConfig.latitude.to_s),
                             BigDecimal.new(AppConfig.longitude.to_s))
  end

  def self.get_official_riseset(date = Time.now.to_date)
    calc = get_calc(date)
    rise = calc.compute_utc_official_sunrise.to_time.getlocal
    set = calc.compute_utc_official_sunset.to_time.getlocal
    { :rise => rise, :set => set, :daylight => self.daylight(rise, set)}
  end

  def self.get_civil_riseset(date = Time.now.to_date)
    calc = get_calc(date)
    rise = calc.compute_utc_civil_sunrise.to_time.getlocal
    set = calc.compute_utc_civil_sunset.to_time.getlocal
    { :rise => rise, :set => set, :daylight => self.daylight(rise, set)}
  end

  def self.get_astronomical_riseset(date = Time.now.to_date)
    calc = get_calc(date)
    rise = calc.compute_utc_astronomical_sunrise.to_time.getlocal
    set = calc.compute_utc_astronomical_sunset.to_time.getlocal
    { :rise => rise, :set => set, :daylight => self.daylight(rise, set)}
  end

  def self.get_nautical_riseset(date = Time.now.to_date)
    calc = get_calc(date)
    rise = calc.compute_utc_nautical_sunrise.to_time.getlocal
    set = calc.compute_utc_nautical_sunset.to_time.getlocal
    { :rise => rise, :set => set, :daylight => self.daylight(rise, set)}
  end

  def self.get_risesets(date = Time.now.to_date)
    { :official => self.get_official_riseset(date),
      :civil => self.get_civil_riseset(date),
      :astronomical => self.get_astronomical_riseset(date),
      :nautical => self.get_nautical_riseset(date) }
  end

    # a very conservative measurement of light and dark. when in doubt, it's light.
  def self.dark?(tm = Time.now)
    r = self.get_nautical_riseset(tm.to_date)
    return (tm < r[:rise] or tm >= r[:set])
  end

end
