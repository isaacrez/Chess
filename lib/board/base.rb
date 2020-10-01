require './lib/board/config'
require './lib/board/display'
require './lib/board/populate'
require './lib/board/turn_manager'
require './lib/piece/base'

class Board
  include BoardConfig, BoardDisplay, BoardPopulate, TurnManager
  attr_reader :content

  def initialize
    @turn = :p1

    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {@@INIT_DISPLAY}}
    populate_board
    display self
  end

  def at(pos)
    x, y = pos
    return @content[y][x]
  end

  def occupied?(pos)
    return at(pos).is_a? Piece
  end

  def occupied_by?(pos, team)
    occupied?(pos) ? at(pos).team == team : false
  end

  def reset_at(pos)
    modify_at pos, @@INIT_DISPLAY
  end

  def imply_move_at(pos)
    modify_at pos, @@MOVE_DISPLAY
  end

  def modify_at(pos, value)
    x, y = pos
    @content[y][x] = value
  end

  def show_moves(piece)
    piece.select

    moves = piece.move_options
    for pos in moves
      if occupied? pos
        at(pos).select unless occupied_by? pos, @turn
      else
        imply_move_at pos
      end
    end

    display self
    hide_moves moves
    piece.deselect
  end

  def hide_moves(moves)
    for move in moves
      tile = at move
      if tile.is_a? Piece
        tile.deselect
      else
        reset_at(move)
      end
    end
  end
end
