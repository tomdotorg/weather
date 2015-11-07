class RadiationController < ApplicationController

  def index
    get_radiation
  end

  def get_radiation
    @current = CurrentCondition.find_by_location(AppConfig.location)
  end
end
