require_relative 'wagon'

class PassWagon < Wagon

  def initialize(wagon_number)
    super
    @type = 'passenger'
  end

end