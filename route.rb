class Route

  include InstanceCounter

# имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними
  attr_reader :station_list

  def initialize (route_name, first_station, last_station)
    @station_list = [first_station, last_station]
    @route_name = route_name
  end

  def route_name
    @route_name
  end


  def add_station(station)
    @station_list.insert(-2,station)
  end

# может удалять промежуточную станцию из списка
  def delete_station(station)
    @station_list.delete(station)
  end

end