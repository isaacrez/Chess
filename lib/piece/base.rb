require './lib/colorize'
require './lib/piece/movement'

class Piece
  include MovementLogic
  attr_accessor :position
  attr_reader :icon, :team

  def self.make(type, team, position, board)
    case type
    when 'king'
      return King.new(type, team, position, board)
    when 'queen'
      return Queen.new(type, team, position, board)
    when 'rook'
      return Rook.new(type, team, position, board)
    when 'bishop'
      return Bishop.new(type, team, position, board)
    when 'knight'
      return Knight.new(type, team, position, board)
    when 'pawn'
      return Pawn.new(type, team, position, board)
    else
      raise "Attempted to construct unknown piece: #{type}"
    end
  end

  private
  def initialize(type, team, position, board)
    @team = team
    @selected = false
    @position = position
    @board = board
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

  def move_to(move)
    self.position = move
    @board.modify_at move, self
  end

  def to_s
    color(@icon)
  end
end

class King < Piece
  def initialize(type, team, position, board)
    super
    @icon = "\u265A"
  end

  def move_options
    rel_moves = [[1, 0], [1, 1], [0, 1], [-1, 0], [-1, -1], [0, -1], [-1, 1], [1, -1]]
    return move_positions_by rel_moves
  end
end

class Queen < Piece
  include DirectionalMovement

  def initialize(type, team, position, board)
    super
    @icon = "\u265B"
  end

  def move_options
    return omnidirectional_move
  end
end

class Rook < Piece
  include DirectionalMovement

  def initialize(type, team, position, board)
    super
    @icon = "\u265C"
  end

  def move_options
    return horizontal_move
  end
end

class Bishop < Piece
  include DirectionalMovement

  def initialize(type, team, position, board)
    super
    @icon = "\u265D"
  end

  def move_options
    return diagonal_move
  end
end

class Knight < Piece
  def initialize(type, team, position, board)
    super
    @icon = "\u265E"
  end

  def move_options
    moves = move_positions_by([[1, 2], [2, 1], [-1, 2], [-2, 1],
                              [-1, -2], [-2, -1], [1, -2], [2, -1]], @board)
    moves.select {|move| not @board.occupied?(move) || @board.occupied_by?(move, other_team)}
    return moves
  end
end

class Pawn < Piece
  def initialize(type, team, position, board)
    super
    @icon = "\u265F"
    @has_moved = false
  end
  
  def move_options
    moves = {
      p1: move_positions_by([[0, 1], [0, 2]]),
      p2: move_positions_by([[0, -1], [0, -2]])
    }

    if @board.occupied? moves[@team][0]
      moves[@team] = []
    elsif @board.occupied? moves[@team][1] or @has_moved
      moves[@team].pop
    end

    attacks = {
      p1: move_positions_by([[1, 1], [-1, 1]]),
      p2: move_positions_by([[1, -1], [-1, -1]])
    }

    for move in attacks[@team]
      if @board.occupied_by? move, other_team
        moves[@team].append move
      end
    end

    return moves[@team]
  end
end