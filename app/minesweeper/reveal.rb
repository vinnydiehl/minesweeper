class MinesweeperGame
  def reveal_cell(x, y)
    # Can't reveal a flagged cell or a cell that's already been revealed
    return if @grid[x][y].flag == :flag || @grid[x][y].revealed?

    @grid[x][y].revealed = true

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
end
