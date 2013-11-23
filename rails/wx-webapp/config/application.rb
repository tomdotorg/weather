class Object
  def returning(value)
    yield(value)
    value
  end
end
# ...
config.time_zone = 'US/Eastern'
