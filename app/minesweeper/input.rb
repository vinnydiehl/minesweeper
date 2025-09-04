class MinesweeperGame
  def process_mouse_inputs
    # Grid stuff follows, don't process grid clicks if we've won or lost
    return if @result

    if @mouse.key_up?(:left) && @mouse_hover_cell
      x, y = @mouse_hover_cell

      handle_first_click(x, y) if @first_click

      reveal_cell(x, y)

      @mouse_hover_cell = nil
      draw_grid_overlay
    end

    if @mouse.key_down_or_held?(:left) && mouse_in_grid?
      @mouse_hover_cell = mouse_grid_location
      draw_grid_overlay
    else
      @mouse_hover_cell = nil
      draw_grid_overlay
    end

    if @mouse.key_down?(:right) && mouse_in_grid?
      x, y = mouse_grid_location
      @grid[x][y].flag =
        FLAG_STATES[(FLAG_STATES.index(@grid[x][y].flag) + 1) % FLAG_STATES.size]
      draw_grid_overlay
    end
  end

  def mouse_in_grid?
    @mouse.intersect_rect?(@grid_rect)
  end

  def mouse_grid_location
    x, y = @mouse.x - @grid_rect[:x], @mouse.y - @grid_rect[:y]
    cell_size = @cell_size * @scale
    [x, y].map { |n| (n / cell_size).floor }
  end

  # If it's the first click, search the cell and surrounding cells for mines
  # and move them away so the first click is on a cell with 0 neighboring mines
  def handle_first_click(x, y)
    @first_click = false

    mines_to_generate = [-1, 0, 1].product([-1, 0, 1]).count do |ox, oy|
      tx, ty = x + ox, y + oy
      cell = cell_at(tx, ty)
      next false unless cell&.mine?

      cell.remove_mine
      @mine_free_cells.delete([tx, ty])
      true
    end

    generate_mines(mines_to_generate)
    find_neighbors
    draw_grid
  end
end
