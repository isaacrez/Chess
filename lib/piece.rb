require './lib/colorize'
require './lib/board_config'

class Piece
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

  def move_positions_from(moves)
    for move in moves do
      move[0] += @position[0]
      move[1] += @position[1]
    end
    return moves   
  end

  public
  def select
    @selected = true
  end

  def deselect
    @selected = false
  end

  def display_attack_by(piece)
    unless piece.team == @team
      @selected = true
    end
  end

  def to_s
    color(@icon)
  end
end

module DirectionalMovement
  include BoardConfig

  def omnidirectional_move
    return diagonal_move.concat(horizontal_move)
  end

  def diagonal_move
    rel_moves = []
    0.upto(@@SIZE[:x] - 1) do |i|
      rel_moves.append [i, i]
      rel_moves.append [-i, i]
      rel_moves.append [i, -i]
      rel_moves.append [-i, -i]
    end
    return rel_moves
  end

  def horizontal_move
    rel_moves = []
    0.upto(@@SIZE[:x] - 1) do |i|
      rel_moves.append [i, 0]
      rel_moves.append [0, i]
      rel_moves.append [-i, 0]
      rel_moves.append [0, -i]
    end
    return rel_moves
  end
end

class King < Piece
  def initialize(type, team, position)
    super
    @icon = "\u265A"
  end

  def move_options
    rel_moves = [[1, 0], [1, 1], [0, 1], [-1, 0], [-1, -1], [0, -1], [-1, 1], [1, -1]]
    return move_positions_from rel_moves
  end
end

class Queen < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265B"
  end

  def move_options
    return move_positions_from omnidirectional_move
  end
end

class Rook < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265C"
  end

  def move_options
    return move_positions_from horizontal_move
  end
end

class Bishop < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265D"
  end

  def move_options
    return move_positions_from diagonal_move
  end
end

class Knight < Piece
  def initialize(type, team, position)
    super
    @icon = "\u265E"
  end

  def move_options
    rel_moves = [
      [1, 2], [2, 1], [-1, 2], [-2, 1],
      [-1, -2], [-2, -1], [1, -2], [2, -1]  
    ]
    return move_positions_from(rel_moves)
  end

end

class Pawn < Piece
  def initialize(type, team, position)
    super
    @icon = "\u265F"
    @has_moved = false
  end
  
  def move_options
    rel_moves = {p1: [], p2: []}

    rel_moves[:p1].append [0, 1]
    rel_moves[:p2].append [0, -1]

    unless @has_moved
      rel_moves[:p1].append [0, 2]
      rel_moves[:p2].append [0, -2]
    end

    return move_positions_from(rel_moves[@team])
  end
end