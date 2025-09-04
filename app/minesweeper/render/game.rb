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
    @display_height = 33
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
    @grid_x_offset = (@frame_left_edge_width - @frame_right_edge_width) * @scale / 2

    grid_w = @grid_width * @scale
    @grid_rect = {
      w: grid_w,
      h: @grid_height * @scale,
      # Center it on screen
      x: ((@screen_width - grid_w) / 2) + @grid_x_offset,
      # Bump by frame height
      y: @frame_bottom_height * @scale,
    }

    @smiley_size = 24
    @smiley_bezel_size = @smiley_size + 2
    smiley_screen_size = @smiley_bezel_size * @scale

    base_y = @frame_bottom_height * @scale
    grid_y = @grid_height * @scale
    bezel_y = @frame_middle_bezel_height * @scale
    display_y = @display_height * @scale / 2
    @smiley_rect = {
      x: (@screen_width / 2) - (smiley_screen_size / 2) + @grid_x_offset,
      y: base_y + grid_y + bezel_y + display_y - (smiley_screen_size / 2),
      w: smiley_screen_size, h: smiley_screen_size,
    }

    init_frame
    draw_grid
    draw_grid_overlay
  end

  def init_frame
    frame = @args.outputs[:frame]
    frame.w = @frame_width
    frame.h = @frame_height

    # The display will be a window to this background
    frame.primitives << {
      primitive_marker: :solid,
      x: 0, y: 0,
      w: @frame_width, h: @frame_height,
      r: 192, g: 192, b: 192,
    }

    # Left/right edges of the display
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

    # Left/right edges of the grid
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

    # Top edge
    frame.primitives << {
      x: @frame_left_edge_width, y: frame.h - @frame_top_height,
      w: @frame_width - @frame_edges_width, h: @frame_top_height,
      path: "sprites/frame/top_edge.png",
    }

    # Bottom edge and bottom corners
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

    # Bezel between display and grid
    frame.primitives << {
      x: @frame_left_edge_width,
      y: frame.h - @frame_display_edge_height,
      w: @frame_width - @frame_edges_width, h: @frame_middle_bezel_height,
      path: "sprites/frame/middle_bezel.png",
    }
  end

  # Draw/redraw functions

  def draw_grid
    grid = @args.outputs[:grid]
    grid.w, grid.h = @grid_width, @grid_height

    @grid.each_with_index do |col, x|
      col.each_with_index do |cell, y|
        grid.primitives << {
          x: x * @cell_size, y: y * @cell_size,
          w: @cell_size, h: @cell_size,
          path: "sprites/cells/#{cell.sprite}.png",
        }
      end
    end
  end

  def draw_grid_overlay
    overlay = @args.outputs[:grid_overlay]
    overlay.w, overlay.h = @grid_width, @grid_height

    @grid.each_with_index do |col, x|
      col.each_with_index do |cell, y|
        next if cell.revealed?

        clicked = [x, y] == @mouse_hover_cell
        sprite = if cell.flag
          # Could be :flag or :question_mark
          cell.flag == :question_mark && clicked ? :question_mark_clicked
                                                 : cell.flag
        else
          clicked ? :empty : :hidden
        end

        overlay.primitives << {
          x: x * @cell_size, y: y * @cell_size,
          w: @cell_size, h: @cell_size,
          path: "sprites/cells/#{sprite}.png",
        }
      end
    end
  end

  def draw_smiley(sprite)
    smiley = @args.outputs[:smiley]
    smiley.w, smiley.h = @smiley_bezel_size, @smiley_bezel_size

    smiley << {
      x: 0, y: 0,
      w: @smiley_bezel_size, h: @smiley_bezel_size,
      path: "sprites/frame/smiley_bezel.png",
    }
    smiley << {
      x: 1, y: 1,
      w: @smiley_size, h: @smiley_size,
      path: "sprites/smileys/#{sprite}.png",
    }
  end

  ### Rendering

  def render_game
    render_background
    render_frame
    render_smiley
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

  def render_smiley
    sprite = if @smiley_mouse_down
      :clicked
    elsif @result
      @result == :win ? :cool : :dead
    elsif @mouse_hover_cell
      :omg
    else
      :smile
    end
    draw_smiley(sprite)

    @primitives << {
      **@smiley_rect,
      path: :smiley,
    }
  end

  def render_grid
    render_grid_target(:grid)
    render_grid_target(
      :grid_overlay,
      # Uncomment to make the overlay transparent for debugging
      # a: 200,
    )
  end

  def render_grid_target(path, a: 255)
    @primitives << {
      **@grid_rect,
      path: path,
      a: a,
    }
  end
end
