SCENES = %w[game].freeze

%w[constants cell minesweeper].each { |f| require "app/minesweeper/#{f}.rb" }

%w[scenes render].each { |dir| SCENES.each { |f| require "app/minesweeper/#{dir}/#{f}.rb" } }

require "app/minesweeper/render/shared.rb"

def tick(args)
  args.state.game ||= MinesweeperGame.new(args)
  args.state.game.tick
end
