module WxHelper

def format_alert(alerts)
    if !alerts.nil?
      a = []
      alerts.each do |i|
         if i["significance"] != "S" && i["significance"] != "N"
          dep = i["description"]
          a << link_to("#{dep}<br>", "#"+i["phenomena"])
        end
      end
      return a.to_s
    end
end

  def alerts_table(alerts)
    if alerts.nil?
    a = []
    a << "<tr><td width=270>No outstanding warning.<br>Geen waarschuwing van kracht.</td></tr>"
    end
   if !alerts.nil?
      a = []
      alerts.each do |i|
	n = i["message"].strip.gsub("\n", "<br>")
        start = i["date"].localtime
        expire = i["expires"].localtime
        color = i["level_meteoalarm_name"]
        a << "<tr><td width=270 bgcolor=#{color}>" +
            "Geldig van #{start.strftime("%a %H:%M")} " +
            "tot #{expire.strftime("%a %H:%M")}.</td></tr><tr><td width=270 bgcolor=#{color}>#{n}</td></tr>"
      end
    end
    return a.to_s
  end

end