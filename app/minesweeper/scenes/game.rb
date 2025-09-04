class MinesweeperGame
  def game_init
    @difficulty = DIFFICULTY[
      # :beginner
      :intermediate
      # :expert
    ]

    reset_game
    render_game_init
  end

  def game_tick; end

  def reset_game
    @grid = Array.new(@difficulty[:w]) do
      Array.new(@difficulty[:h]) { Cell.new }
    end

    # Can be nil, :win, or :lose
    @result = nil

    # Generate mines randomly
    coords_list = (0...@difficulty[:w]).to_a.product(0...@difficulty[:h])
    @difficulty[:mines].times do
      x, y = coords_list.delete_at(rand(coords_list.length))
      @grid[x][y].set_mine
    end

    # Traverse the grid and count neighboring mines for cells that
    # don't contain mines
    @grid.each_with_index do |col, x|
      col.each_with_index do |cell, y|
        next if cell.mine?

        cell.neighbors = OFFSETS.count do |ox, oy|
          tx, ty = x + ox, y + oy

          # Bounds check
          if tx < 0 || ty < 0 || tx >= @grid.length || ty >= col.length
            next false
          end

          @grid[tx][ty].mine?
        end
      end
    end
  end
end
