require './lib/board_display'
require './lib/board_populate'
require './lib/piece'

class Board
  include BoardDisplay
  include BoardPopulate

  @@SIZE = {x: 8, y: 8}

  def initialize
    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {' '}}
    populate_board @content
    display @content
  end



end

board = Board.new
