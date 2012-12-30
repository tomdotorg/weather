require 'wunder_almanac'

class WxController < ApplicationController
  include REXML

  def index
    check_applet_status()
    periods
    get_current_conditions
    get_noaa_forecast
    get_climate
    get_riseset
    get_alerts
  end

  def enable_applet
    cookies[:applet_enabled] = { :value => "true", :expires => 1.minute.from_now }
    redirect_to :action => "index"
  end

  def check_applet_status
    @applet = cookies[:applet_enabled].present?
  end

  def get_alerts
    @alerts = Alert.current.to_a
    @alert_list = []
    @alerts.each do |a|
      @alert_list << a.description
    end
  end

  def enable_wunderground_forecast
    cookies[:use_wunderground] = { :value => "true", :expires => 1.minute.from_now }
    redirect_to :action => "index"
  end

  def disable_wunderground_forecast
    cookies.delete([:use_wunderground])
    redirect_to :action => "index"
  end

  def get_noaa_forecast
    @noaa_forecast = NoaaForecast.latest(AppConfig.noaa_location)
    @noaa_forecast_available = !@noaa_forecast.nil? and @noaa_forecast.last_retrieved < 6.hours.ago
    @wunder_forecast = WunderForecast.latest(AppConfig.wunderground_location)
    @wunder_forecast_available = !@wunder_forecast.nil? and @wunder_forecast.last_retrieved < 6.hours.ago
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
    @riseset_today = Riseset.riseset(AppConfig.climate_location, Time.now)
    @riseset_available = !(@riseset_today.nil?)
    @riseset_week = Riseset.riseset(AppConfig.climate_location, Time.now + 1.week)
    @riseset_two_weeks = Riseset.riseset(AppConfig.climate_location, Time.now + 2.weeks)
    @riseset_month = Riseset.riseset(AppConfig.climate_location, Time.now + 1.month)
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
    @dark = Riseset.dark?(AppConfig.location, Time.now.utc)
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
