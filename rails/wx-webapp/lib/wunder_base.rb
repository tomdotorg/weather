require 'logger'
require 'wunderground'

class WunderBase
  def initialize
    @location = AppConfig.wunderground_location
    @key = AppConfig.wunderground_key
    @api = Wunderground.new(@key)
    @api.language = AppConfig.wunderground_lang ||= "EN"
  end
end
