class MinesweeperGame
  def process_mouse_inputs
    if @mouse.key_up?(:left) && @mouse_hover_cell
      x, y = @mouse_hover_cell

      # Can't reveal a flagged cell
      return if @grid[x][y].flag == :flag

      @grid[x][y].revealed = true

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
end
