class MinesweeperGame
  def render_game_init
    init_frame
  end

  def init_frame
    # Hardcoded sized from the sprites
    @frame_edge_width = 12
    @frame_bottom_height = 8
    @frame_top_height = 11
    @frame_middle_bezel_height = 11
    @frame_display_height = 33
    @cell_size = 16

    @frame_height = 319
    # Width of the frame will differ based on amount of cells
    @frame_width = (@frame_edge_width * 2) + (DIFFICULTY[@level][:w] * @cell_size)

    scale_x = @screen_width / @frame_width
    scale_y = @screen_height / @frame_height
    @scale = [scale_x, scale_y].min

    frame = @args.outputs[:frame]
    frame.w = @frame_width
    frame.h = @frame_height

    frame.primitives << {
      x: 0, y: 0,
      w: @frame_edge_width, h: @frame_height,
      path: "sprites/frame/left_edge.png",
    }
    frame.primitives << {
      x: @frame_width - @frame_edge_width, y: 0,
      w: @frame_edge_width ,h: @frame_height,
      path: "sprites/frame/right_edge.png",
    }
    frame.primitives << {
      x: @frame_edge_width, y: 0,
      w: @frame_width - (@frame_edge_width * 2), h: @frame_bottom_height,
      path: "sprites/frame/bottom_edge.png",
    }
    frame.primitives << {
      x: @frame_edge_width, y: frame.h - @frame_top_height,
      w: @frame_width - (@frame_edge_width * 2), h: @frame_top_height,
      path: "sprites/frame/top_edge.png",
    }
    frame.primitives << {
      x: @frame_edge_width,
      y: frame.h - @frame_top_height - @frame_display_height - @frame_middle_bezel_height,
      w: @frame_width - (@frame_edge_width * 2), h: @frame_middle_bezel_height,
      path: "sprites/frame/middle_bezel.png",
    }
  end

  def render_game
    render_background
    render_frame
  end

  def render_frame
    w = @frame_width * @scale
    h = @frame_height * @scale

    # Center it on screen
    x = (@screen_width - w) / 2
    y = (@screen_height - h) / 2

    @args.outputs << {
      x: x, y: y,
      w: w, h: h,
      path: :frame,
    }
  end
end
