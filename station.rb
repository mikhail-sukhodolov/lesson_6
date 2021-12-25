class Station
  
  include InstanceCounter

# имеет название, которое указывается при ее создании
# может возвращать список всех поездов на станции, находящиеся в текущий момент
  attr_accessor :trains

  @@all_stations = []

  def self.all
    @@all_stations
  end


  def initialize (station_name)
    @station_name = station_name
    @trains = []
    @@all_stations << self
  end

  def station_name
    @station_name
  end

# может принимать поезда (по одному за раз)
  def get_train(train)
    @trains << train
  end

# может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def departure(train)
    @trains.delete(train)
  end

# может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def get_type(type)
    @trains.select {|train| train.type == type}            
  end

end