require './lib/colorize'

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
    for move in moves[@team] do
      move[0] += @position[0]
      move[1] += @position[1]
    end
    return moves[@team]   
  end

  public
  def toggle
    @selected = !@selected
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
end

class Queen < Piece
    def initialize(type, team, position)
    super
    @icon = "\u265B"
  end
end

class Rook < Piece
    def initialize(type, team, position)
    super
    @icon = "\u265C"
  end
end

class Bishop < Piece
    def initialize(type, team, position)
    super
    @icon = "\u265D"
  end
end

class Knight < Piece
    def initialize(type, team, position)
    super
    @icon = "\u265E"
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

    return move_positions_from(rel_moves)
  end
end