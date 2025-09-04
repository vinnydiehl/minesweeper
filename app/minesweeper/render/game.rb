class MinesweeperGame
  ### Initialization

  def render_game_init
    # Hardcoded sized from the sprites
    @frame_left_edge_width = 12
    @frame_right_edge_width = 8
    @frame_bottom_height = 8
    @frame_top_height = 11
    @frame_middle_bezel_height = 11
    @frame_display_edge_height = 55
    @cell_size = 16

    @grid_width = @difficulty[:w] * @cell_size
    @grid_height = @difficulty[:h] * @cell_size

    @frame_edges_width = @frame_left_edge_width + @frame_right_edge_width

    @frame_height = @frame_display_edge_height + @frame_bottom_height + @grid_height
    @frame_width = @frame_edges_width + @grid_width

    scale_x = @screen_width / @frame_width
    scale_y = @screen_height / @frame_height
    @scale = [scale_x, scale_y].min

    # Since the borders are different widths, we need to offset the grid
    # to the right a few pixels.
    @grid_x_offset = (@frame_left_edge_width - @frame_right_edge_width) * (@scale / 2)

    init_frame
    init_grid
  end

  def init_frame
    frame = @args.outputs[:frame]
    frame.w = @frame_width
    frame.h = @frame_height

    frame.primitives << {
      x: 0, y: @frame_height - @frame_display_edge_height,
      w: @frame_left_edge_width, h: @frame_display_edge_height,
      path: "sprites/frame/display_left_edge.png",
    }
    frame.primitives << {
      x: @frame_width - @frame_right_edge_width,
      y: @frame_height - @frame_display_edge_height,
      w: @frame_right_edge_width, h: @frame_display_edge_height,
      path: "sprites/frame/display_right_edge.png",
    }

    frame.primitives << {
      x: 0, y: @frame_bottom_height,
      w: @frame_left_edge_width, h: @grid_height,
      path: "sprites/frame/left_edge.png",
    }
    frame.primitives << {
      x: @frame_width - @frame_right_edge_width, y: @frame_bottom_height,
      w: @frame_right_edge_width, h: @grid_height,
      path: "sprites/frame/right_edge.png",
    }

    frame.primitives << {
      x: @frame_left_edge_width, y: frame.h - @frame_top_height,
      w: @frame_width - @frame_edges_width, h: @frame_top_height,
      path: "sprites/frame/top_edge.png",
    }

    frame.primitives << {
      x: 0, y: 0,
      w: @frame_left_edge_width, h: @frame_bottom_height,
      path: "sprites/frame/bottom_left_corner.png",
    }
    frame.primitives << {
      x: @frame_width - @frame_right_edge_width, y: 0,
      w: @frame_right_edge_width, h: @frame_bottom_height,
      path: "sprites/frame/bottom_right_corner.png",
    }
    frame.primitives << {
      x: @frame_left_edge_width, y: 0,
      w: @grid_width, h: @frame_bottom_height,
      path: "sprites/frame/bottom_edge.png",
    }

    frame.primitives << {
      x: @frame_left_edge_width,
      y: frame.h - @frame_display_edge_height,
      w: @frame_width - @frame_edges_width, h: @frame_middle_bezel_height,
      path: "sprites/frame/middle_bezel.png",
    }
  end

  def init_grid
    grid = @args.outputs[:grid]
    grid.w, grid.h = @grid_width, @grid_height

    @grid.each_with_index do |col, x|
      col.each_with_index do |cell, y|
        sprite = if cell.mine
          "mine"
        else
          "empty"
        end

        grid.primitives << {
          x: x * @cell_size, y: y * @cell_size,
          w: @cell_size, h: @cell_size,
          path: "sprites/cells/#{sprite}.png",
        }
      end
    end
  end

  ### Rendering

  def render_game
    render_background
    render_frame
    render_grid
  end

  def render_frame
    w = @frame_width * @scale
    h = @frame_height * @scale

    # Center it on screen
    x = (@screen_width - w) / 2

    @primitives << {
      x: x, y: 0,
      w: w, h: h,
      path: :frame,
    }
  end

  def render_grid
    w = @grid_width * @scale
    h = @grid_height * @scale

    # Center it on screen
    x = ((@screen_width - w) / 2) + @grid_x_offset
    # Bump by frame height
    y = @frame_bottom_height * @scale

    @primitives << {
      x: x, y: y,
      w: w, h: h,
      path: :grid,
    }
  end
end
