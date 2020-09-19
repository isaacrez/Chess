require './lib/colorize'

class Piece
  attr_reader :movement, :icon, :team

  def initialize(value, team)
    @icon = value
    @team = team
  end

  def color(str)
    @team == :p1 ? str.red : str.blue
  end

  def to_s
    color(@icon)
  end
end
