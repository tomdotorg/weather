require 'logger'
require 'wunderground'
require 'json'

class WunderConditionManager < WunderBase
  log = Logger.new(STDOUT)
  log.level = Logger::INFO

  def store_conditions
    c = get_conditions
    a = WunderConditions.find_or_create_by_location(@location)
    a.conditions_raw = c
    a.conditions = c["weather"]
    a.visibility = c["visibility_mi"]
    a.visibility_m = c["visibility_km"]
    a.location_desc = c["display_location"]["full"]
    a.as_of = Time.parse(c["observation_time_rfc822"])
    a.icon_url = c["icon_url"]
    a.save!
  end

  def get_conditions
    @api.conditions_for(@location)["current_observation"]
  end
end

w = WunderConditionManager.new
c = w.store_conditions()
