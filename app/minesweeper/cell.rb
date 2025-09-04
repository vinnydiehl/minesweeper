class Cell
  attr_accessor *%i[revealed mine flag neighbors sprite]
  attr_reader *%i[mine neighbors]

  def initialize
    @revealed = false
    @mine = false

    # Can either be nil, :flag, or :question_mark
    @flag = nil

    # This will remain 0 if it's a mine, otherwise contains the
    # number of surrounding mines
    @neighbors = 0

    # The sprite for the main grid (not the overlay)
    @sprite = :empty

    def revealed?
      revealed
    end

    def mine?
      mine
    end

    def set_mine
      @mine = true
      @sprite = :mine
    end

    def remove_mine
      @mine = false
      @sprite = :empty
    end

    def neighbors=(n)
      @neighbors = n
      @sprite = n == 0 ? :empty : n
    end
  end
end
