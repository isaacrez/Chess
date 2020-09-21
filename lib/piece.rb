require './lib/colorize'
require './lib/piece_modules'

class Piece
  include MovementLogic
  attr_reader :icon, :team

  def self.make(type, team, position)
    case type
    when 'king'
      return King.new(type, team, position)
    when 'queen'
      return Queen.new(type, team, position)
    when 'rook'
      return Rook.new(type, team, position)
    when 'bishop'
      return Bishop.new(type, team, position)
    when 'knight'
      return Knight.new(type, team, position)
    when 'pawn'
      return Pawn.new(type, team, position)
    else
      raise "Attempted to construct unknown piece: #{type}"
    end
  end

  private
  def initialize(type, team, position)
    @team = team
    @selected = false
    @position = position
  end

  def color(str)
    if @selected
      @team == :p1 ? str.pink : str.light_blue
    else
      @team == :p1 ? str.red : str.blue
    end
  end

  def other_team
    @team == :p1 ? :p2 : :p1
  end

  public
  def select
    @selected = true
  end

  def deselect
    @selected = false
  end

  def to_s
    color(@icon)
  end
end

class King < Piece
  def initialize(type, team, position)
    super
    @icon = "\u265A"
  end

  def move_options(board)
    rel_moves = [[1, 0], [1, 1], [0, 1], [-1, 0], [-1, -1], [0, -1], [-1, 1], [1, -1]]
    return move_positions_by rel_moves, board
  end
end

class Queen < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265B"
  end

  def move_options(board)
    return move_positions_by omnidirectional_move, board
  end
end

class Rook < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265C"
  end

  def move_options(board)
    return move_positions_by horizontal_move, board
  end
end

class Bishop < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265D"
  end

  def move_options(board)
    return move_positions_by diagonal_move, board
  end
end

class Knight < Piece
  def initialize(type, team, position)
    super
    @icon = "\u265E"
  end

  def move_options(board)
    moves = move_positions_by([[1, 2], [2, 1], [-1, 2], [-2, 1],
                              [-1, -2], [-2, -1], [1, -2], [2, -1]], board)
    moves.select {|move| not board.occupied?(move) || board.occupied_by?(move, other_team)}
    return moves
  end
end

class Pawn < Piece
  def initialize(type, team, position)
    super
    @icon = "\u265F"
    @has_moved = false
  end
  
  def move_options(board)
    moves = {
      p1: move_positions_by([[0, 1], [0, 2]], board),
      p2: move_positions_by([[0, -1], [0, -2]], board)
    }

    if board.occupied? moves[@team][0]
      moves[@team] = []
    elsif board.occupied? moves[@team][1] or @has_moved
      moves[@team].pop
    end

    attacks = {
      p1: move_positions_by([[1, 1], [-1, 1]], board),
      p2: move_positions_by([[1, -1], [-1, -1]], board)
    }

    for move in attacks[@team]
      if board.occupied_by? move, other_team
        moves[@team].append move
      end
    end

    return moves[@team]
  end
end