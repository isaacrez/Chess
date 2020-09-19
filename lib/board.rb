require './lib/board_display'

class Board
  include BoardDisplay

  @@SIZE = {x: 8, y: 8}

  def initialize
    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {'o'}}
    Displayer.display @content
  end
end

board = Board.new
