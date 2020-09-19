require './lib/board_display'
require './lib/piece'

class Board
  include BoardDisplay

  @@SIZE = {x: 8, y: 8}

  def initialize
    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {' '}}
    add_pawns
    add_ranked
    Displayer.display @content
  end

  def add_pawns
    0.upto 7 do |i|
      @content[1][i] = Piece.new('p', :p1)
      @content[6][i] = Piece.new('p', :p2)
    end
  end

  def add_ranked
    pieces = ['R', 'k', 'B', 'K', 'Q', 'B', 'k', 'R']

    0.upto 7 do |i|
      @content[0][i] = Piece.new(pieces[i], :p1)
      @content[7][i] = Piece.new(pieces[i], :p2)
    end
  end

end

board = Board.new
