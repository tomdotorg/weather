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
    if !alerts.nil?
      a = []
      alerts.each do |i|
	n = i["message"].strip.gsub("\n", "<br>")
        start = i["date"].localtime
        expire = i["expires"].localtime
        a << "<tr><td width=270>" +
            "Geldig van #{start.strftime("%a %H:%M")} " +
            "tot #{expire.strftime("%a %H:%M")}.</td></tr><tr><td width=270>#{n}</td></tr>"
      end
    else
    a = []
    a << "<tr><td width=270><b>No outstanding warnings.<br>Geen waarschuwingen van kracht.</b></td></tr>"
    end
    return a.to_s
  end

end