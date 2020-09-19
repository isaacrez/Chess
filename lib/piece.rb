require './lib/colorize'

class Piece
  attr_reader :movement, :icon, :team

  @@ICONS = {
    king: "\u265A",
    queen: "\u265B",
    rook: "\u265C",
    bishop: "\u265D",
    knight: "\u265E",
    pawn: "\u265F"
  }

  def initialize(type, team)
    @type = type
    @icon = @@ICONS[type.to_sym]
    @team = team
  end

  def color(str)
    @team == :p1 ? str.red : str.blue
  end

  def to_s
    color(@icon)
  end
end
