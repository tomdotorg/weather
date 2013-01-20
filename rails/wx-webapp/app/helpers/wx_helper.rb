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
        a << "<tr><th id=\"#{i["phenomena"]}\">#{i["description"]}</th></tr><tr><td>" +
            "In effect from #{start.strftime("%I:%M %p on %A")}<br>" +
            "until #{expire.strftime("%I:%M %p on %A")}.</td></tr><tr><td>#{n}</td></tr>"
      end
    end
    return a.to_s
  end

end