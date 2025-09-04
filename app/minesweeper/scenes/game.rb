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

  def game_tick
    process_mouse_inputs
  end

  def reset_game
    @grid = Array.new(@difficulty[:w]) do
      Array.new(@difficulty[:h]) { Cell.new }
    end

    # Need to keep track of this so that if the first click is near a mine,
    # we can move them
    @first_click = true

    # Can be nil, :win, or :lose
    @result = nil

    # Generate mines randomly
    @mine_free_cells = (0...@difficulty[:w]).to_a.product(0...@difficulty[:h])
    generate_mines(@difficulty[:mines])

    find_neighbors

    # Cell that the mouse is hovering over with the left mouse
    # button held down
    @mouse_hover_cell = nil

    # Are we holding the mouse down over the smiley?
    @smiley_mouse_down = false

    # Mines remaining (subtracts with each flag placed regardless of
    # whether the flag is actually over a mine)
    @remaining = @difficulty[:mines]
  end

  def generate_mines(n)
    n.times do
      x, y = @mine_free_cells.delete_at(rand(@mine_free_cells.length))
      @grid[x][y].set_mine
    end
  end

  # Traverse the grid and count neighboring mines for cells that
  # don't contain mines
  def find_neighbors
    @grid.each_with_index do |col, x|
      col.each_with_index do |cell, y|
        next if cell.mine?

        cell.neighbors = OFFSETS.count do |ox, oy|
          tx, ty = x + ox, y + oy
          neighbor = cell_at(tx, ty)
          neighbor&.mine?
        end
      end
    end
  end
end
