class Cell
  attr_accessor *%i[revealed mine flag neighbors]

  def initialize
    @revealed = false
    @mine = false

    # Can either be nil, :flag, or :question_mark
    @flag = nil

    # This will remain nil if it's a mine, otherwise contains the
    # number of surrounding mines
    @neighbors = nil
  end
end
