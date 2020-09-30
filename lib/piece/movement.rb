require './lib/board/config'

module MovementLogic
  include BoardConfig
  
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
end

module HorizontalMovement
  @@HORZ_DIR = {UP: 0, RIGHT: 1, DOWN: 2, LEFT: 3}

  def horizontal_move(board)
    HorizontalMove.new(board, @position).get_moves
  end

  class HorizontalMove
    include MovementLogic

    def initialize(board, position)
      @board = board
      @position = position
      @moves = []
      config_iterators
    end

    def config_iterators
      x, y = @position
      @iter = {
        up: (0...y).to_a.reverse,
        right: ((x + 1)..8).to_a,
        down: ((y + 1)..8).to_a,
        left: (0...x).to_a.reverse
      }
    end

    def get_moves
      @iter.each_key do |dir|
        get_moves_in dir
      end
      
      return @moves
    end

    def get_moves_in(dir)
      x, y = @position
      iterator = @iter[dir]
  
      iterator.each do |i|
        pos = is_vertical?(dir) ? [x, i] : [i, y]
        valid_move?(pos, @board) ? @moves.append(pos) : break
        @board.occupied?(pos) ? break : next
      end
    end

    def is_vertical?(dir)
      dir == :up || dir == :down
    end
  end
end

module DiagonalMovement
  def diagonal_move(board)
    DiagonalMove.new(board, @position).get_moves
  end

  class DiagonalMove
    include MovementLogic

    def initialize(board, position)
      config_iterators(position)
      @board = board
      @moves = []
    end

    def config_iterators(position)
      x, y = position

      @x_iter = {
        up_left: ((x + 1)..8).to_a,
        up_right: ((x + 1)..8).to_a,
        down_left: (0...x).to_a.reverse,
        down_right: (0...x).to_a.reverse
      }

      @y_iter = {
        up_left: ((y + 1)..8).to_a,
        up_right: (0...y).to_a.reverse,
        down_left: (0...y).to_a.reverse,
        down_right: ((y + 1)..8).to_a
      }
    end

    def get_moves
      @x_iter.each_key do |dir|
        get_moves_in dir
      end
      
      return @moves
    end

    def get_moves_in(dir)
      length = move_length(dir)
      0.upto(length) do |i|
        pos = [@x_iter[dir][i], @y_iter[dir][i]]
        valid_move?(pos, @board) ? @moves.append(pos) : break
        @board.occupied?(pos) ? break : next
      end
    end

    def move_length(dir)
      [@x_iter[dir].size, @y_iter[dir].size].min - 1
    end
  end
end

module DirectionalMovement
  include BoardConfig
  include DiagonalMovement
  include HorizontalMovement

  def omnidirectional_move(board)
    return diagonal_move(board).concat(horizontal_move(board))
  end
end
