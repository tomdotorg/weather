require 'date'
require '../lib/solareventcalculator'

date = Date.parse('2008-11-01')
calc = SolarEventCalculator.new(date, BigDecimal.new("39.9537"), BigDecimal.new("-75.7850"))

utcOfficialSunrise = calc.compute_utc_official_sunrise
localOfficialSunrise = calc.compute_official_sunrise('America/New_York')

puts "utcOfficialSunrise #{utcOfficialSunrise}"
puts "localOfficialSunrise #{localOfficialSunrise}"
