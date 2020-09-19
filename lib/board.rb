require './lib/board_display'
require './lib/piece'

class Board
  include BoardDisplay

  @@SIZE = {x: 8, y: 8}

  def initialize
    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {' '}}
    populate_board
    Displayer.display @content
  end

  def populate_board
    add_pawns
    add_ranked
  end

  def add_pawns
    0.upto 7 do |i|
      @content[1][i] = Piece.new('pawn', :p1)
      @content[6][i] = Piece.new('pawn', :p2)
    end
  end

  def add_ranked
    pieces = ['rook', 'knight', 'bishop', 'knight', 'queen', 'bishop', 'knight', 'rook']

    0.upto 7 do |i|
      @content[0][i] = Piece.new(pieces[i], :p1)
      @content[7][i] = Piece.new(pieces[i], :p2)
    end
  end

end

board = Board.new
