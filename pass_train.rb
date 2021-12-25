require_relative 'train'

class PassTrain < Train

  def initialize(train_number)
    super
    @type = 'passenger'
  end

end