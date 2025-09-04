class Cell
  attr_accessor *%i[revealed mine flag neighbors]

  def initialize
    @revealed = false
    @mine = false

    # Can either be nil, :flag, or :question_mark
    @flag = nil

    # This will remain 0 if it's a mine, otherwise contains the
    # number of surrounding mines
    @neighbors = 0

    def revealed?
      revealed
    end

    def mine?
      mine
    end
  end
end
