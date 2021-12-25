require_relative 'train'
require_relative 'cargo_train'
require_relative 'pass_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'pass_wagon'
require_relative 'company_name'
require_relative 'instance_counter'

class Main

  attr_accessor :stations, :trains, :routes

  def initialize
    @trains = []
    @routes = []
    @stations = []
  end

  def menu
    loop do
      puts "Выберите действие: "
      puts "1. Создать станцию"
      puts "2. Создать поезд"
      puts "3. Добавить или отцепить вагон"
      puts "4. Создать маршрут"
      puts "5. Добавить/удалить станцию маршрута"
      puts "6. Назначать маршрут поезду"
      puts "7. Переместить поезд"
      puts "8. Показать все станции"
      puts "9. Показать все поезда на станции"
      puts "0. Выход"
      actions
    end
  end
  
  def actions
    input = gets.to_i
    case input
    when 1
      create_station
    when 2
      create_train
    when 3
      edit_wagons
    when 4
      create_route
    when 5
      edit_route
    when 6
      assign_route_to_train
    when 7
      move_train
    when 8
      list_of_stations
    when 9
      trains_on_station
    when 0
      exit
    end
  end

  private
  #методы используются внутри класса

  def create_station
    puts "Введите название станции"
    station = gets.chomp
    @stations << Station.new(station)
    puts "Станция #{station} создана"    
  end

  def create_train
    puts "Создаем новый поезд. Введите номер"
    train_number = gets.chomp
    puts "Укажите тип 'cargo' или 'passenger'"
    type = gets.chomp
    case type
    when 'cargo'
      @trains << CargoTrain.new(train_number)
      puts "Поезд создан" 
    when 'passenger'
      @trains << PassTrain.new(train_number)
      puts "Поезд создан" 
    else
      puts "Некорректное значение" 
    end
  end

  def all_trains
     @trains.each_with_index { |train, n| puts "позиция #{n}, номер #{train.train_number}, тип #{train.type}"}
  end

  def edit_wagons
    puts "Выберите позицию поезда из списка"
    puts all_trains
    position = gets.to_i
    if @trains[position].speed != 0
      puts "Поезд движется, сначала остановите его"
      return
    end
    puts "Вы хотите добавить вагон (1) или удалить (2)"
    choise = gets.to_i
    if choise == 1
      type = @trains[position].type
      puts "Введите номер вагона"
      wagon_number = gets.chomp
      case type
      when 'cargo'
        @trains[position].add_wagon(CargoWagon.new(wagon_number))
      when 'passenger'
        @trains[position].add_wagon(PassWagon.new(wagon_number))
      end
      puts "Вагон добавлен"
    end
    if choise == 2
      if @trains[position].wagons.empty?
        puts "У поезда нет вагонов"
        return
      end
      @trains[position].wagons.pop
      puts "Последний вагон отцеплен"
    end
      puts "В поезде #{@trains[position].train_number} вагоны со следующими номерами:"
      @trains[position].wagons.each{ |wagon| puts "#{wagon.wagon_number}" }
  end
 
  def create_route
    if @stations.empty?
      puts "Нет ни одной станции для добавления"
      return
    end
    puts "Введите название маршрута"
    route_name = gets.chomp
    puts "Выберите позицию станции из списка - отправную точку маршрута"
    list_of_stations
    first_station = @stations[gets.to_i]
    puts "Выберите позицию станции из списка - последнюю точку маршрута"
    list_of_stations
    last_station = @stations[gets.to_i]
    @routes << Route.new(route_name, first_station, last_station)
    puts "Маршрут создан. Все доступные маршруты: #{@routes}"
  end

  def all_routes
    @routes.each_with_index{ |route, n| puts "позиция #{n} имя маршрута #{route.route_name}" }
  end

  def edit_route
    if @routes.empty?
      puts "Нет ни одного маршрута для редактирования"
      return
    end
    puts "Выберите позицию маршрута из списка для редактирования"
    puts all_routes
    position = gets.to_i
    puts "Вы хотите добавить станцию(1) или удалить(2)?"
    choise = gets.to_i
    if choise == 1
      puts "Выберите позицию станции из списка для добавления"
      list_of_stations
      new_station = @stations[gets.to_i]
      @routes[position].add_station(new_station)
      puts "Станция добавлена. В маршруте следующие станции:"
      @routes[position].station_list.each{ |station| puts "#{station.station_name}" }
    end
    if choise == 2
      if @routes[position].station_list.empty?
        puts "В маршруте нет станций"
        return
      end
      puts "Укажите позицию станции в маршруте для удаления:"
      @routes[position].station_list.each_with_index{ |station, n| puts "позиция #{n} имя станции #{station.station_name}" }
      station_position = gets.to_i
      station = @routes[position].station_list[station_position]
      @routes[position].delete_station(station)
      puts "Станция удалена. В маршруте следующие станции:"
      @routes[position].station_list.each{ |station| puts "#{station.station_name}" }
    end
  end

 def assign_route_to_train
    if @trains.empty?
      puts "Нет ни одного поезда для редактирования"
      return
    end
    if @routes.empty?
      puts "Нет ни одного маршрута для редактирования"
      return
    end
    puts "Выберите позицию поезда из списка"
    puts all_trains
    train_position = gets.to_i
    puts "Выберите позицию маршрута из списка"
    puts all_routes
    route_position = gets.to_i
    @trains[train_position].add_route(@routes[route_position])
    puts "Маршрут #{@routes[route_position].route_name} назначен поезду c номером #{@trains[train_position].train_number}"
  end

  def move_train
    if @trains.empty?
      puts "Нет ни одного поезда"
      return
    end
    puts "Выберите позицию поезда из списка для перемещения"
    puts all_trains
    position = gets.to_i
    if @trains[position].route == nil
      puts "Для этого поезда не назначен маршрут"
      return
    end
    puts "Вы хотите переместить поезд вперед(1) или назад(2)?"
    choise = gets.to_i
    case choise
    when 1
      @trains[position].move_forward
      puts "Текущая станция: #{@trains[position].cur_station.station_name}"
    when 2
      @trains[position].move_back
      puts "Текущая станция: #{@trains[position].cur_station.station_name}"
    end
  end

  def list_of_stations
    puts "Список всех станций:" 
    @stations.each_with_index{ |station, n| puts "позиция #{n} название станции #{station.station_name}" }
  end

  def trains_on_station
    puts "Выберите позицию станции"
    puts list_of_stations
    position = gets.to_i
    if @stations[position].trains.empty?
      puts "На станции нет ни одного поезда"
      return
    end
    @stations[position].trains.each {|train| puts "Номера поездов на станции: #{train.train_number}"}
  end

end