require 'wunder_almanac'
require 'astro'
require 'wx_utils'

class WxController < ApplicationController
  include REXML

  def index
    periods
    get_current_conditions
    get_noaa_forecast
    get_climate
    get_riseset
    get_alerts
  end

  def get_alerts
    @alerts = Alert.current.to_a
    @alert_list = []
    @alerts.each do |a|
      @alert_list << a.description
    end
  end

  def get_noaa_forecast
    @forecast = NoaaForecast.latest(AppConfig.noaa_location)
    @wunder_forecast = WunderForecast.latest(AppConfig.wunderground_location)
  end

  def get_climate
    wm = WunderAlmanacManager.new
    c = wm.get_almanac
    if !c.nil?
      @normal_high = c.avg_high_temp
      @normal_low = c.avg_low_temp
      @record_high = c.record_high_temp
      @record_high_temp_year = c.record_high_temp_year
      @record_low = c.record_low_temp
      @record_low_temp_year = c.record_low_temp_year
      @climate_available = true
    else
      @climate_available = false
    end
  end

  def get_riseset
    @risesets={}
#    ree-1.8.7-2010.02 > @risesets = {}
##     => {}
#    ree-1.8.7-2010.02 > @risesets[:nautical]={"foo"=>"bar", "bar" => "foo"}
#     => {"foo"=>"bar", "bar"=>"foo"}
##    ree-1.8.7-2010.02 > @risesets
#     => {:nautical=>{"foo"=>"bar", "bar"=>"foo"}}
#    ree-1.8.7-2010.02 >
    @riseset_available = true
    @official_riseset_today = Astro.get_official_riseset
    @official_riseset_tomorrow = Astro.get_official_riseset(Time.now + 1.day)
    @official_offset_tomorrow = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_tomorrow[:daylight])
    @official_riseset_week = Astro.get_official_riseset(Time.now + 1.week)
    @official_offset_week = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_week[:daylight])
    @official_riseset_two_weeks = Astro.get_official_riseset(Time.now + 2.weeks)
    @official_offset_two_weeks = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_two_weeks[:daylight])
    @official_riseset_month = Astro.get_official_riseset(Time.now + 1.month)
    @official_offset_month = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_month[:daylight])
    @official_riseset_two_months = Astro.get_official_riseset(Time.now + 2.months)
    @official_offset_two_months = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_two_months[:daylight])
    @official_riseset_three_months = Astro.get_official_riseset(Time.now + 3.months)
    @official_offset_three_months = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_three_months[:daylight])
    @official_riseset_six_months = Astro.get_official_riseset(Time.now + 6.months)
    @official_offset_six_months = WxUtils.hhmm_between_dates(@official_riseset_today[:daylight],
                                                           @official_riseset_six_months[:daylight])

    @civil_riseset_today = Astro.get_civil_riseset
    @civil_riseset_tomorrow = Astro.get_civil_riseset(Time.now + 1.day)
    @civil_offset_tomorrow = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_tomorrow[:daylight])
    @civil_riseset_week = Astro.get_civil_riseset(Time.now + 1.week)
    @civil_offset_week = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_week[:daylight])
    @civil_riseset_two_weeks = Astro.get_civil_riseset(Time.now + 2.weeks)
    @civil_offset_two_weeks = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_two_weeks[:daylight])
    @civil_riseset_month = Astro.get_civil_riseset(Time.now + 1.month)
    @civil_offset_month = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_month[:daylight])
    @civil_riseset_two_months = Astro.get_civil_riseset(Time.now + 2.months)
    @civil_offset_two_months = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_two_months[:daylight])
    @civil_riseset_three_months = Astro.get_civil_riseset(Time.now + 3.months)
    @civil_offset_three_months = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_three_months[:daylight])
    @civil_riseset_six_months = Astro.get_civil_riseset(Time.now + 6.months)
    @civil_offset_six_months = WxUtils.hhmm_between_dates(@civil_riseset_today[:daylight],
                                                        @civil_riseset_six_months[:daylight])
  end

  def get_airport_conditions
    wunder_conditions = WunderConditions.latest(AppConfig.wunderground_location)
    if wunder_conditions ==  nil || wunder_conditions.as_of.localtime < 2.hours.ago
      wunder_conditions = NoaaConditions.latest(AppConfig.noaa_location)
    end
    if (wunder_conditions != nil && wunder_conditions.as_of.localtime > 2.hours.ago)
      @conditions = wunder_conditions.conditions
      @conditions_date = wunder_conditions.as_of.localtime
      @visibility = wunder_conditions.visibility
      @conditions_location_desc = wunder_conditions.location_desc
    end
  end

  def periods
    @today = WxPeriod.today_summary(AppConfig.location)
    @this_hour = WxPeriod.this_hour_summary(AppConfig.location)
    @this_week = WxPeriod.this_week_summary(AppConfig.location)
    @this_month = WxPeriod.this_month_summary(AppConfig.location)

    @yesterday = WxPeriod.yesterday_summary(AppConfig.location)
    @last_hour = WxPeriod.last_hour_summary(AppConfig.location)
    @last_week = WxPeriod.last_week_summary(AppConfig.location)
    @last_month = WxPeriod.last_month_summary(AppConfig.location)
  end

  def last_rain
    l = LastRain.find_by_location(AppConfig.location)
    l.nil? ? nil : l.last_rain
  end
  
  def get_current_conditions
    get_airport_conditions
    @current = CurrentCondition.find_by_location(AppConfig.location)
    @dark = Astro.dark?
    # kludge for time sync problems btw station time and web server
    @current.sample_date = Time.now if !@current.nil? and @current.sample_date > Time.now
    @today = WxPeriod.today_summary(AppConfig.location)
    if @today != nil
      if (@current.outside_temperature.to_f >= @today.hiTemp.to_f) 
        @highlo = "<br>(daily high)</br>"
      else
        if (@current.outside_temperature.to_f <= @today.lowTemp.to_f)
          @highlo = "<br>(daily low)</br>"
        end
      end
      @last_rain = last_rain
    end
    get_climate
    get_riseset
  end

  def current_conditions
    get_current_conditions
    render(:template => "wx/_current_conditions",
           :layout => false)
  end
  
  def period
    periods
    render(:template => "wx/_period",
           :layout => false)
  end
end
