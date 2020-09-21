require './lib/board_config'
require './lib/board_display'
require './lib/board_populate'
require './lib/piece'
require './lib/turn_manager'

class Board
  include BoardConfig, BoardDisplay, BoardPopulate, TurnManager

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
      if inbounds? move
        x, y = move
        if @content[y][x].is_a? Piece
          @content[y][x].display_attack_by piece
        else
          @content[y][x] = '?'
        end
      end
    end

    display @content
    piece.toggle
  end

  def inbounds?(move)
    x, y = move
    (0 <= x && x < @@SIZE[:x]) && (0 <= y && y < @@SIZE[:y])
  end

  def hide_moves

  end
end

board = Board.new
