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

module HORZ_DIRectionalMovement
  include BoardConfig

  @@HORZ_DIR = {UP: 0, RIGHT: 1, DOWN: 2, LEFT: 3}

  def omni_directional_move
    return diagonal_move.concat(horizontal_move)
  end

  def diagonal_move(board)
    moves = []
    x_i, y_i = @position

    return moves
  end

  def horizontal_move(board)
    moves = []
    x_i, y_i = @position

    @@HORZ_DIR.each_value do |HORZ_DIR|
      moves.concat(add_horizontal(board, HORZ_DIR))
    end

    return moves
  end

  def add_horizontal(board, HORZ_DIR)
    moves = []
    x, y = @position
    iterator = get_horz_iterator(HORZ_DIR)

    iterator.each do |i|
      pos = is_vertical?(HORZ_DIR) ? [x, i] : [i, y]
      valid_move?(pos, board) ? moves.append(pos) : break
      board.occupied?(pos) ? break : next
    end

    return moves
  end

  def is_vertical?(HORZ_DIR)
    HORZ_DIR == @@HORZ_DIR[:UP] || HORZ_DIR == @@HORZ_DIR[:DOWN]
  end

  def get_horz_iterator(HORZ_DIR)
    x, y = @position
    case HORZ_DIR
    when @@HORZ_DIR[:UP]
      iterator = (0...y).to_a.reverse
    when @@HORZ_DIR[:RIGHT]
      iterator = ((x + 1)..8).to_a
    when @@HORZ_DIR[:DOWN]
      iterator = ((y + 1)..8).to_a
    when @@HORZ_DIR[:LEFT]
      iterator = (0...x).to_a.reverse
    end
  end
end
