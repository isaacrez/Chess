module BoardDisplay

  def display(board)
    display_obj = Displayer.new board
    display_obj.display
  end

  class Displayer
    @@GRID = {
      top_left: "\u250C",
      top_right: "\u2510",
      bottom_left: "\u2514",
      bottom_right: "\u2518",
      horz: "\u2500",
      vert: "\u2502",
      full_inter: "\u253C",
      top_inter: "\u252C",
      bottom_inter: "\u2534",
      right_inter: "\u2524",
      left_inter: "\u251C"
    }

    def initialize(board)
      @content = board.content
      @curr_row = 0
    end

    def display
      output = add_horizontal_label
      output += top_bar

      board = []
      for row in @content do
        board.append prettify row
      end
      output += board.join mid_bar
  
      output += bottom_bar
      puts output
    end

    private
    def add_horizontal_label
      labels = "ABCDEFGH"
      ' ' * 4 + labels.split('').join(' ' * 3)
    end

    def top_bar
      output = "\n  #{@@GRID[:top_left]}"
      output += (@@GRID[:horz] * 3 + @@GRID[:top_inter]) * 7
      output += @@GRID[:horz] * 3 + @@GRID[:top_right] + "\n"
    end

    def prettify(row)
      output = add_vertical_label
      output += ' ' + @@GRID[:vert] + ' '
      output += row.join(@@GRID[:vert].center(3))
      output += ' ' + @@GRID[:vert]
    end

    def add_vertical_label
      @curr_row += 1
      @curr_row.to_s
    end

    def mid_bar
      output = "\n  " + @@GRID[:left_inter]
      output += (@@GRID[:horz] * 3 + @@GRID[:full_inter]) * 7
      output += @@GRID[:horz] * 3 + @@GRID[:right_inter] + "\n"
    end

    def bottom_bar
      output = "\n  " + @@GRID[:bottom_left]
      output += (@@GRID[:horz] * 3 + @@GRID[:bottom_inter]) * 7
      output += @@GRID[:horz] * 3 + @@GRID[:bottom_right]
    end
  end
end
