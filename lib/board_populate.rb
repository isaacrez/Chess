module BoardPopulate

  def populate_board(content)
    populater = BoardPopulater.new(content)
    return populater.content
  end

  class BoardPopulater
    attr_reader :content

    def initialize(content)
      @content = content
      populate_board
    end

    private
    def populate_board
      add_pawns
      add_ranked
    end

    def add_pawns
      0.upto 7 do |i|
        @content[1][i] = Piece.make('pawn', :p1)
        @content[6][i] = Piece.make('pawn', :p2)
      end
    end

    def add_ranked
      pieces = ['rook', 'knight', 'bishop', 'knight', 'queen', 'bishop', 'knight', 'rook']

      0.upto 7 do |i|
        @content[0][i] = Piece.make(pieces[i], :p1)
        @content[7][i] = Piece.make(pieces[i], :p2)
      end
    end
  end

end