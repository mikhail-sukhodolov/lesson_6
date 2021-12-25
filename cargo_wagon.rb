require_relative 'wagon'

class CargoWagon < Wagon
  
  def initialize(wagon_number)
    super
    @type = 'cargo'
  end

end