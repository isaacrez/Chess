require './lib/colorize'

class Piece
  attr_reader :movement, :icon, :team

  def self.make(type, team)
    case type
    when 'king'
      return King.new(type, team)
    when 'queen'
      return Queen.new(type, team)
    when 'rook'
      return Rook.new(type, team)
    when 'bishop'
      return Bishop.new(type, team)
    when 'knight'
      return Knight.new(type, team)
    when 'pawn'
      return Pawn.new(type, team)
    else
      raise "Attempted to construct unknown piece: #{type}"
    end
  end

  private
  def initialize(type, team)
    @team = team
    @selected = false
  end

  public
  def color(str)
    if @selected
      @team == :p1 ? str.pink : str.light_blue
    else
      @team == :p1 ? str.red : str.blue
    end
  end

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
  def initialize(type, team)
    super
    @icon = "\u265A"
  end
end

class Queen < Piece
  def initialize(type, team)
    super
    @icon = "\u265B"
  end
end

class Rook < Piece
  def initialize(type, team)
    super
    @icon = "\u265C"
  end
end

class Bishop < Piece
  def initialize(type, team)
    super
    @icon = "\u265D"
  end
end

class Knight < Piece
  def initialize(type, team)
    super
    @icon = "\u265E"
  end
end

class Pawn < Piece
  def initialize(type, team)
    super
    @icon = "\u265F"
  end
end