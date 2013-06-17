## create the view current_conditions on weewx-table raw, so that
## RoR recognizes and accepts the weewx-data
create or replace view current_conditions (
location,sample_date,outside_temperature,outside_humidity,
dewpoint,pressure,windspeed,wind_direction,
rain_rate,uv,solar_radiation,daily_rain,
inside_temperature,inside_humidity,extra_temp1) 
as select 
'WELSUMVP',from_unixtime(datetime),round(outtemp,1),round(outhumidity,0),
round(dewpoint,1),round(barometer,3),round(windspeed,1),round(winddir,0),
round(rainrate,3),round(uv,1),round(radiation,0),round(dayrain,3),
round(intemp,1),round(inhumidity,0),round(extratemp1,1)
from raw order by datetime desc limit 1;

## create the view archive_records on weewx-table archive, so that
## RoR recognizes and accepts the weewx-data

create or replace view archive_records (
date,location,outside_temp,high_outside_temp,
low_outside_temp,pressure,outside_humidity,rainfall,
high_rain_rate,average_wind_speed,high_wind_speed,direction_of_high_wind_speed,
prevailing_wind_direction,inside_temp,average_dewpoint,average_apparent_temp,
inside_humidity,average_solar_radiation,average_uv_index,et,
high_solar_radiation,high_uv_index,forecastRule,leaf_temp_1,
leaf_temp_2,leaf_wetness1,leaf_wetness2,soil_temp1,
soil_temp2,soil_temp3,soil_temp4,extra_humidity1,
extra_humidity2,extra_temp1,extra_temp2,extra_temp3,
soil_moisture1,soil_moisture2,soil_moisture3,soil_moisture4,
number_of_wind_samples,download_record_type,created_at,updated_at,
outside_temp_m,low_outside_temp_m,high_outside_temp_m,inside_temp_m,
pressure_m,rainfall_m,high_rain_rate_m,average_wind_speed_m,
high_wind_speed_m,average_dewpoint_m,average_apparent_temp_m,high_extra_temp1,
low_extra_temp1,extra_temp1_m,high_extra_temp1_m,low_extra_temp1_m,
et_m)
as select
convert_tz(from_unixtime(datetime),'+0:00','-2:00'),'WELSUMVP',round(outTemp,1),round(outTemp,1),
round(outTemp,1),round(barometer,3),round(outHumidity,0),rain,
round(rainRate,3),round(windSpeed,1),round(windGust,1),round(windGustDir,0),
round(windDir,0),round(inTemp,0),round(dewpoint,1),
case 
when outtemp <= 50 then round(windchill,1)
when outtemp> 80 then round(heatindex,1)
else round(outtemp,1)
end 
as apparent_temp
,
round(inHumidity,0),round(radiation,0),round(UV*10,1),ET,
round(radiation,0),round(UV*10,1),1,round(leafTemp1,1),
round(leafTemp2,1),round(leafWet1,1),round(leafWet2,1),round(soilTemp1,1),
round(soilTemp2,1),round(soilTemp3,1),round(soilTemp4,1),round(extraHumid1,0),
round(extraHumid2,0),round(extraTemp1,1),round(extraTemp2,1),round(extraTemp3,1),
round(soilMoist1,0),round(soilMoist2,0),round(soilMoist3,0),round(soilMoist4,0),
110,1,from_unixtime(dateTime),from_unixtime(dateTime),
1,1,1,1,
1,1,1,1,
1,1,1,1,
1,1,1,1,
1
from archive order by dateTime asc;