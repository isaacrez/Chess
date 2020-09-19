require './lib/board_display'
require './lib/board_populate'
require './lib/piece'

class Board
  include BoardDisplay
  include BoardPopulate

  @@SIZE = {x: 8, y: 8}
  @@PLAYER_COLORS = {
    p1: 'red',
    p2: 'blue'
  }

  def initialize
    @turn = :p1

    @content = Array.new(@@SIZE[:x]) {Array.new(@@SIZE[:y]) {' '}}
    populate_board @content
    display @content
    
    take_turn
  end

  def take_turn
    color = @@PLAYER_COLORS[@turn]
    puts "It is #{color}'s turn"
    selected = nil

    loop do
      print "Select a piece to move:\t"
      x, y = get_input
      selected = @content[y][x]

      if selected.is_a? Piece
        if selected.team == @turn
          selected.toggle
          display @content
          selected.toggle
        else
          puts "That's not yours!"
        end
      else
        puts "There's no piece there!"
      end
    end
  end

  def get_input
    input = gets.chomp.split(',').map!(&:to_i)
  end

  def switch
    @turn == :p1 ? :p2 : :p1
  end
end

board = Board.new
