class MinesweeperGame
  def reveal_cell(x, y)
    # Can't reveal a flagged cell or a cell that's already been revealed
    return if @grid[x][y].flag == :flag || @grid[x][y].revealed?

    # If we reveal a mine, it explodes :(
    if @grid[x][y].mine?
      @result = :loss
      reveal_lose(x, y)
    end

    @grid[x][y].revealed = true

    if win?
      @result = :win
      reveal_win
    end

    if @grid[x][y].neighbors == 0 && !@grid[x][y].mine?
      # Floodfill
      OFFSETS.each do |ox, oy|
        tx, ty = x + ox, y + oy

        # Bounds check
        next if tx < 0 || ty < 0 || tx >= @grid.length || ty >= @grid[0].length

        reveal_cell(tx, ty)
      end
    end
  end

  # Called when a mine is revealed. Reveals all cells, and changes sprites for
  # the exploded mine and false flags.
  def reveal_lose(mine_x, mine_y)
    @grid.each_with_index do |col, x|
      col.each_with_index do |cell, y|
        if cell.flag == :flag
          if !cell.mine?
            cell.revealed = true
            cell.sprite = :mine_wrong
          end
        elsif [x, y] == [mine_x, mine_y]
          cell.sprite = :mine_exploded
        elsif cell.mine?
          cell.revealed = true
        end
      end
    end

    draw_grid
  end

  # When we win, flag all mines
  def reveal_win
    @grid.flatten.select(&:mine?).each { |c| c.flag = :flag }
  end

  def win?
    @grid.flatten.reject(&:revealed?).all?(&:mine?)
  end
end
