module BoardPopulate

  def populate_board
    populater = BoardPopulater.new(self)
    return populater.content
  end

  class BoardPopulater
    attr_reader :content

    def initialize(board)
      @board = board
      populate_board
    end

    private
    def populate_board
      add_pawns
      add_ranked
    end

    def add_pawns
      0.upto 7 do |i|
        add_piece('pawn', :p1, [i, 1])
        add_piece('pawn', :p2, [i, 6])
      end
    end

    def add_ranked
      pieces = ['rook', 'knight', 'bishop', 'king', 'queen', 'bishop', 'knight', 'rook']

      0.upto 7 do |i|
        add_piece(pieces[i], :p1, [i, 0])
        add_piece(pieces[i], :p2, [i, 7])
      end
    end

    def add_piece(type, player, position)
      x, y = position
      @board.content[y][x] = Piece.make(type, player, position, @board)
    end
  end

end