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
    @selected = false
  end

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
