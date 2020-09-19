require './lib/board_display'
require './lib/board_populate'
require './lib/piece'
require './lib/turn_manager'

class Board
  include BoardDisplay, BoardPopulate, TurnManager

  @@SIZE = {x: 8, y: 8}

  def initialize
    @turn = :p1

    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {' '}}
    populate_board @content
    display @content
    
    take_turn
  end
end

board = Board.new
