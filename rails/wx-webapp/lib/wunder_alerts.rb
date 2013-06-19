require 'logger'
require 'wunderground'
require 'json'

class WunderAlertManager < WunderBase
  def store_alerts
    a = get_alerts
    Alert.destroy_all(:location => @location)
    num_alerts = a["response"]["features"]["alerts"]
    if num_alerts > 0
      a["alerts"].each do |alert|
        adate = Time.parse(alert["date"]).utc
        atype = alert["type"]
        a = Alert.find_or_create_by_location_and_date_and_atype(@location, adate, atype)
        a.phenomena = alert["phenomena"]
        a.significance = alert["significance"]
        a.description = alert["description"]
        a.date = Time.parse(alert["date"]).utc
        a.expires = Time.parse(alert["expires"]).utc
        a.message = alert["message"]
        a.wtype_meteoalarm = alert["wtype_meteoalarm"]
        a.wtype_meteoalarm_name = alert["wtype_meteoalarm_name"]
        a.level_meteoalarm = alert["level_meteoalarm"]
        a.level_meteoalarm_name = alert["level_meteoalarm_name"]
        a.level_meteoalarm_description = alert["level_meteoalarm_description"]
        a.attribution = alert["attribution"]
        a.save!
      end
    end
  end

  def get_alerts
    @api.alerts_for(@location)
  end
end

w = WunderAlertManager.new
c = w.store_alerts()
