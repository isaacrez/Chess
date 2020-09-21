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

  def reset_at(*args)
    modify_at(args.flatten, ' ')
  end

  def imply_move_at(*args)
    modify_at(args.flatten, '?')
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

    moves = piece.move_options(self).select {|move| inbounds? move}
    
    for move in moves
      if inbounds? move
        tile = self.at(move)
        if tile.is_a? Piece
          tile.display_attack_by piece
        else
          imply_move_at move
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
      tile = at move
      if tile.is_a? Piece
        tile.deselect
      else
        reset_at(move)
      end
    end
  end
end

board = Board.new
