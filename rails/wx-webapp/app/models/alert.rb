class Alert < ActiveRecord::Base
  SIGNIFICANCE_MAPPINGS = { "W" => "Warning",
                            "F" => "Forecast",
                            "A" => "Watch",
                            "O" => "Outlook",
                            "Y" => "Advisory",
                            "N" => "Synopsis",
                            "S" => "Statement" }

  PHENOM_MAPPINGS = {   "AF" => "Ashfall", "AS" => "Air Stagnation", "BS" => "Blowing Snow",
                        "BW" => "Brisk Wind", "BZ" => "Blizzard", "CF" => "Coastal Flood",
                        "DS" => "Dust Storm", "DU" => "Blowing Dust", "EC" => "Extreme Cold",
                        "EH" => "Excessive Heat", "EW" => "Extreme Wind", "FA" => "Areal Flood",
                        "FF" => "Flash Flood", "FG" => "Dense Fog", "FL" => "Flood", "FR" => "Frost",
                        "FW" => "Fire Weather", "FZ" => "Freeze", "GL" => "Gale",
                        "HF" => "Hurricane Force Wind", "HI" => "Inland Hurricane", "HS" => "Heavy Snow",
                        "HT" => "Heat", "HU" => "Hurricane", "HW" => "High Wind",
                        "HY" => "Hydrologic", "HZ" => "Hard Freeze", "IP" => "Sleet", "IS" => "Ice Storm",
                        "LB" => "Lake Effect Snow and Blowing Snow", "LE" => "Lake Effect Snow",
                        "LO" => "Low Water", "LS" => "Lakeshore Flood", "LW" => "Lake Wind Marine",
                        "MA" => "Marine", "RB" => "Small Craft for Rough Bar", "SB" => "Snow and Blowing Snow",
                        "SC" => "Small Craft", "SE" => "Hazardous Seas", "SI" => "Small Craft for Winds",
                        "SM" => "Dense Smoke", "SN" => "Snow", "SR" => "Storm", "SU" => "High Surf",
                        "SV" => "Severe Thunderstorm", "SW" => "Small Craft for Hazardous Seas",
                        "TI" => "Inland Tropical Storm", "TO" => "Tornado", "TR" => "Tropical Storm",
                        "TS" => "Tsunami", "TY" => "Typhoon", "UP" => "Ice Accretion",
                        "WC" => "Wind Chill", "WI" => "Wind", "WS" => "Winter Storm",
                        "WW" => "Winter Weather", "ZF" => "Freezing Fog", "ZR" => "Freezing Rain" }

  named_scope :current, lambda {{:conditions => ["expires > ? and location = \'#{AppConfig.wunderground_location}\'", Time.now.utc], :order => "date DESC"}}

  def self.phenomena_to_s(p)
    PHENOM_MAPPINGS[p]
  end

  def self.significance_to_s(s)
    SIGNIFICANCE_MAPPINGS[s]
  end
end

