# sync a development environment from a production one
#  - uses web services
# 

require 'soap/wsdlDriver'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG

src_url="http://www.tom.org/weather/wsdl"
src_soap = SOAP::WSDLDriverFactory.new(src_url).create_rpc_driver
log.debug(src_soap)
dest_url="http://localhost:3000/weather/wsdl"
dest_soap = SOAP::WSDLDriverFactory.new(dest_url).create_rpc_driver
log.debug(dest_soap)

while true do

  begin
    10.times do
      log.debug("getting conditions.")
      t = Time.now
      conditions = src_soap.GetCurrentConditions("01915")
      log.debug(conditions)
      log.debug(Time.now - t)
      log.debug("writing")
      t = Time.now
      dest_soap.PutCurrentConditions("wx", "01915", conditions)
      log.debug("done.")
      log.debug(Time.now - t)
      sleep 5
    end

    last_archive = dest_soap.GetLastArchive("01915")
    if (last_archive.nil?)
      date = Time.parse("1/1/1970")
    else
      log.debug(last_archive.date)
      date = last_archive.date
    end

    archive_structs = src_soap.GetArchiveSince("wx", "01915", date)
    log.debug("returned #{archive_structs.length} entries")

    archive_structs.each do |s|
      t = Time.now
      dest_soap.PutArchiveEntry("wx", "01915", s)
      log.debug(s.date)
      log.debug(Time.now - t)
    end
  end
end
