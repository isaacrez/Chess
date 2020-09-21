require './lib/colorize'
require './lib/board_config'

class Piece
  include BoardConfig
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

  def move_positions_by(moves, board)
    move_pool = []

    for move in moves do
      move_pool.append move_pos_by move, board
      move_pool.pop if move_pool.last.nil?
    end
    
    return move_pool
  end

  def move_pos_by(move, board)
    move[0] += @position[0]
    move[1] += @position[1]
    if valid_move? move, board
      return move
    else
      return nil
    end
  end

  def valid_move?(move, board)
    inbounds?(move) && not(board.occupied_by?(move, @team))
  end

  def inbounds?(move)
    (0 <= move[0] && move[0] < @@SIZE[:x]) && (0 <= move[1] && move[1] < @@SIZE[:y])
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

  def move_options(board)
    rel_moves = [[1, 0], [1, 1], [0, 1], [-1, 0], [-1, -1], [0, -1], [-1, 1], [1, -1]]
    return move_positions_by rel_moves
  end
end

class Queen < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265B"
  end

  def move_options(board)
    return move_positions_by omnidirectional_move
  end
end

class Rook < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265C"
  end

  def move_options(board)
    return move_positions_by horizontal_move
  end
end

class Bishop < Piece
  include DirectionalMovement

  def initialize(type, team, position)
    super
    @icon = "\u265D"
  end

  def move_options(board)
    return move_positions_by diagonal_move
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
      p1: [move_pos_by([0, 1], board), move_pos_by([0, 2], board)],
      p2: [move_pos_by([0, -1], board), move_pos_by([0, -2], board)]
    }

    if board.occupied? moves[@team][0]
      moves[@team] = []
    elsif board.occupied? moves[@team][1] or @has_moved
      moves[@team].pop
    end

    return moves[@team]
  end
end