require 'wunderground'
require 'json'
require 'time'

class WunderForecastManager < WunderBase
  log = Logger.new(STDOUT)
  log.level = Logger::INFO

  def store_10_day_forecasts
    a = get_10_day_forecast
    forecast = WunderForecast.find_or_create_by_location(AppConfig.wunderground_location)
    forecast.wunder_forecast_periods.destroy_all
    forecast.wunder_forecast_period_longs.destroy_all
    forecast.creation_time = Time.parse(a["date"]).utc
    forecast.creation_time = forecast.creation_time - 1.day if forecast.creation_time > Time.now.utc
    forecast.last_retrieved = Time.now.utc
    forecast.forecast_raw = a
    forecast.save!


    a["forecastday"].each do |pd|  # should be 20 of them, but no need to assume that.

      forecast.wunder_forecast_periods << WunderForecastPeriod.new(
              :pdnum => pd["period"],
              :name => pd["title"],
              :text => pd["fcttext"],
              :textmetric => pd["fcttext_metric"],
              :icon_location => pd["icon_url"])
    end
  end

# structure of 10day and regiular forecasts are the same - is the content? no, slightly different

  def do_something_smart
    #    simple_forecasts.elements.each("forecastday") do | pd |
    #      forecast.wunder_forecast_period_longs << WunderForecastPeriodLong.new(
    #        :date => Time.at(pd.elements['date'].elements['epoch'].text.to_i).to_datetime,
    #        :high => pd.elements['high'].elements['fahrenheit'].text.to_f,
    #        :high_m => pd.elements['high'].elements['celsius'].text.to_f,
    #        :low => pd.elements['low'].elements['fahrenheit'].text.to_f,
    #        :low_m => pd.elements['low'].elements['celsius'].text.to_f,
    #        :conditions => pd.elements['conditions'].text,
    #        :icon_location => pd.elements['icons'][1].elements['icon_url'].text)
    #    end
  end

  def get_3_day_forecast
    @api.forecast_for(@location)
  end

  def get_10_day_forecast  # returns an array of 20 periods
    @api.forecast10day_for(@location)["forecast"]["txt_forecast"]
  end

end

w = WunderForecastManager.new
f = w.store_10_day_forecasts

#
                               #["forecastday"]

#f["forecast"]["txt_forecast"]["forecastday"].size

#f["forecast"]["txt_forecast"]["forecastday"][0]
# => {"title"=>"Sunday",
#     "icon_url"=>"http://icons-ak.wxug.com/i/c/k/partlycloudy.gif",
#     "period"=>0,
#     "fcttext_metric"=>"Clear in the morning, then partly cloudy.
#          High of 4C with a windchill as low as -9C. Windy. Winds from the WSW
#          at 20 to 30 km/h with gusts to 45 km/h.",
#     "icon"=>"partlycloudy",
#     "pop"=>"0",
#     "fcttext"=>"Clear in the morning, then partly cloudy. High of 39F
#          with a windchill as low as 16F. Breezy. Winds from the WSW at 15 to
#          20 mph with gusts to 30 mph."}
