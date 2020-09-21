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

  def show_moves(piece)
    piece.toggle

    moves = piece.move_options
    for move in moves do
      x, y = move
      if @content[y][x].is_a? Piece
        @content[y][x].toggle
      else
        @content[y][x] = '?'
      end
    end

    display @content
    piece.toggle
  end

  def hide_moves

  end
end

board = Board.new
