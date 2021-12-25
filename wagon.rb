require_relative 'company_name'


class Wagon

  include CompanyName

  attr_reader :type

  def initialize(wagon_number)
    @wagon_number = wagon_number
  end
  
  def wagon_number
    @wagon_number
  end

end