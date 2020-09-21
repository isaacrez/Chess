require './lib/board_config'

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
