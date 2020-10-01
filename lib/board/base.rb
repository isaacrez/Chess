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

  def at(*args)
    case args.size
    when 1
      x, y = args[0]
    when 2
      x = args[0]
      y = args[1]
    end

    @content[y][x]
  end

  def occupied?(*args)
    return at(args.flatten).is_a? Piece
  end

  def occupied_by?(*args)
    team = args[-1]
    tile = at(args[0...-1].flatten)

    if tile.is_a? Piece
      if tile.team == team
        return true
      end
    end
    
    return false
  end

  def reset_at(*args)
    modify_at(args.flatten, @@INIT_DISPLAY)
  end

  def imply_move_at(*args)
    modify_at(args.flatten, @@MOVE_DISPLAY)
  end

  def modify_at(*args)
    x, y, value = nil
    case args.size
    when 2
      x, y = args[0]
      value = args[1]
    when 3
      x, y, value = args
    end
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
