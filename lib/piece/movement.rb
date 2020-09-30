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

module DirectionalMovement
  include BoardConfig

  @@HORZ_DIR = {UP: 0, RIGHT: 1, DOWN: 2, LEFT: 3}

  def omnidirectional_move(board)
    return diagonal_move(board).concat(horizontal_move(board))
  end

  def diagonal_move(board)
    moves = []
    x_i, y_i = @position

    x_iter = ((x_i + 1)..8).to_a
    y_iter = ((y_i + 1)..8).to_a
    length = [x_iter.size, y_iter.size].min - 1

    0.upto(length) do |i|
      pos = [x_iter[i], y_iter[i]]
      valid_move?(pos, board) ? moves.append(pos) : break
      board.occupied?(pos) ? break : next
    end

    x_iter = ((x_i + 1)..8).to_a
    y_iter = (0...y_i).to_a.reverse
    length = [x_iter.size, y_iter.size].min - 1

    0.upto(length) do |i|
      pos = [x_iter[i], y_iter[i]]
      valid_move?(pos, board) ? moves.append(pos) : break
      board.occupied?(pos) ? break : next
    end

    x_iter = (0...x_i).to_a.reverse
    y_iter = (0...y_i).to_a.reverse
    length = [x_iter.size, y_iter.size].min - 1

    0.upto(length) do |i|
      pos = [x_iter[i], y_iter[i]]
      valid_move?(pos, board) ? moves.append(pos) : break
      board.occupied?(pos) ? break : next
    end

    x_iter = (0...x_i).to_a.reverse
    y_iter = ((y_i + 1)..8).to_a
    length = [x_iter.size, y_iter.size].min - 1

    0.upto(length) do |i|
      pos = [x_iter[i], y_iter[i]]
      valid_move?(pos, board) ? moves.append(pos) : break
      board.occupied?(pos) ? break : next
    end

    return moves
  end

  def horizontal_move(board)
    moves = []
    x_i, y_i = @position

    @@HORZ_DIR.each_value do |dir|
      moves.concat(add_horizontal(board, dir))
    end

    return moves
  end

  def add_horizontal(board, dir)
    moves = []
    x, y = @position
    iterator = get_horz_iterator(dir)

    iterator.each do |i|
      pos = is_vertical?(dir) ? [x, i] : [i, y]
      valid_move?(pos, board) ? moves.append(pos) : break
      board.occupied?(pos) ? break : next
    end

    return moves
  end

  def is_vertical?(dir)
    dir == @@HORZ_DIR[:UP] || dir == @@HORZ_DIR[:DOWN]
  end

  def get_horz_iterator(dir)
    x, y = @position
    case dir
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
