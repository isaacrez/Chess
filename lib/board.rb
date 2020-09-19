require './lib/board_display'
require './lib/piece'

class Board
  include BoardDisplay

  @@SIZE = {x: 8, y: 8}

  def initialize
    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {' '}}
    add_pawns
    Displayer.display @content
  end

  def add_pawns
    @content[1].map! do |cell|
      cell = Piece.new('p', :p1)
    end

    @content[6].map! do |cell|
      cell = Piece.new('p', :p2)
    end
  end

end

board = Board.new
