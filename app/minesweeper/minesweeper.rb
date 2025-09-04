# Constructor and main #tick method for the game runner class which is set
# to `args.state.game` in `main.rb`.
class MinesweeperGame
  def initialize(args)
    @args = args
    @state = args.state

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @inputs = args.inputs

    # Outputs
    @outputs = args.outputs
    @debug = args.outputs.debug
    @sounds = args.outputs.sounds
    @primitives = args.outputs.primitives
    @static_primitives = args.outputs.static_primitives
    @sprites = args.outputs.sprites

    @scene = :game
    game_init
    render_game_init
  end

  def tick
    # Save this so that even if the scene changes during the tick, it is
    # still rendered before switching scenes.
    scene = @scene
    send "#{scene}_tick"
    send "render_#{scene}"

    # Reset game, for development
    if @inputs.keyboard.key_down.backspace
      @args.gtk.reboot
    end
  end
end
