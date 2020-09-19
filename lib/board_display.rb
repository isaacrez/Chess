module BoardDisplay

  def display(board_content)
    display_obj = Displayer.new board_content
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

    def initialize(board_content)
      @content = board_content
    end

    def display
      output = top_bar

      board = []
      for row in @content do
        board.append prettify row
      end
      output += board.join mid_bar
  
      output += bottom_bar
      puts output
    end

    private
    def top_bar
      output = @@GRID[:top_left]
      output += (@@GRID[:horz] * 3 + @@GRID[:top_inter]) * 7
      output += @@GRID[:horz] * 3 + @@GRID[:top_right] + "\n"
    end

    def prettify(row)
      output = @@GRID[:vert] + ' '
      output += row.join(@@GRID[:vert].center(3))
      output += ' ' + @@GRID[:vert]
    end

    def mid_bar
      output = "\n" + @@GRID[:left_inter]
      output += (@@GRID[:horz] * 3 + @@GRID[:full_inter]) * 7
      output += @@GRID[:horz] * 3 + @@GRID[:right_inter] + "\n"
    end

    def bottom_bar
      output = "\n" + @@GRID[:bottom_left]
      output += (@@GRID[:horz] * 3 + @@GRID[:bottom_inter]) * 7
      output += @@GRID[:horz] * 3 + @@GRID[:bottom_right]
    end
  end
end
