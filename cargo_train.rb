require_relative 'train'

class CargoTrain < Train

  def initialize(train_number)
    super
    @type = 'cargo'
  end

end