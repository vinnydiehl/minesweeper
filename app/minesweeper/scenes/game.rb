class MinesweeperGame
  def game_init
    @difficulty = DIFFICULTY[
      # :beginner
      :intermediate
      # :expert
    ]

    reset_game
  end

  def game_tick; end

  def reset_game
    @grid = Array.new(@difficulty[:w]) do
      Array.new(@difficulty[:h]) { Cell.new }
    end

    coords_list = (0...@difficulty[:w]).to_a.product(0...@difficulty[:h])
    @difficulty[:mines].times do
      x, y = coords_list.delete_at(rand(coords_list.length))
      @grid[x][y].mine = true
    end
  end
end
