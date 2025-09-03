class MinesweeperGame
  def game_init
    @difficulty = DIFFICULTY[:intermediate]

    reset_game
  end

  def game_tick; end

  def reset_game
    @grid = Array.new(@difficulty[:w]) do
      Array.new(@difficulty[:h], nil)
    end
  end
end
