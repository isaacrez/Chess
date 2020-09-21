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

  def at(*args)
    case args.size
    when 1
      pos = args[0]
      x, y = pos
      return @content[y][x]
    when 2
      x = args[0]
      y = args[1]
      return @content[y][x]
    end
  end

  def show_moves(piece)
    piece.select

    moves = piece.move_options(self).select {|move| inbounds? move}
    
    for move in moves
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
    hide_moves moves
    piece.deselect
  end

  def inbounds?(move)
    x, y = move
    (0 <= x && x < @@SIZE[:x]) && (0 <= y && y < @@SIZE[:y])
  end

  def hide_moves(moves)
    for move in moves
      x, y = move
      if @content[y][x].is_a? Piece
        @content[y][x].deselect
      else
        @content[y][x] = ' '
      end
    end
  end
end

board = Board.new
