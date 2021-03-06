class WeatherApi < ActionWebService::API::Base
  api_method :reset_cache,
             :expects => [{:password=>:string},
                          {:location=>:string}],
             :returns => nil

  api_method :get_current_conditions,
             :expects => [{:location=>:string}],
             :returns => [SampleStruct]

  api_method :get_last_archive,
             :expects => [{:location=>:string}],
             :returns => [ArchiveStruct]

  api_method :get_archive_since,
             :expects => [{:password=>:string},
                          {:location=>:string},
                          {:since=>:time}],
             :returns => [[ArchiveStruct]]

  api_method :put_current_conditions,
             :expects => [{:password=>:string},
                          {:location=>:string},
                          {:sample=>InputSampleStruct}]

  api_method :put_archive_entry,
             :expects => [{:password=>:string},
                          {:location=>:string},
                          {:entry=>ArchiveStruct}]

  api_method :get_period,
             :expects => [{:password=>:string},
                          {:location=>:string},
                          {:period=>:string}],
             :returns => [PeriodStruct]

  api_method :get_rise_set,
             :expects => [{:password => :string},
                          {:date => :time},
                          {:location => :string}],
             :returns => [Riseset]

  api_method :get_climate,
             :expects => [{:password => :string},
                          {:date => :time},
                          {:location => :string}],
             :returns => [Climate]
end
