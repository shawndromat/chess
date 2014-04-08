class Board
  attr_reader :rows

  def initialize
    @rows  = Array.new(8) {Array.new(8)}
    # set_pieces
  end

  def set_pieces
    @rows[0][0] = Rook.new([0,0], self, :black)
    @rows[0][1] = Knight.new([0,1], self, :black)
    @rows[0][2] = Bishop.new([0,2], self, :black)
    @rows[0][3] = Queen.new([0,3], self, :black)
    @rows[0][4] = King.new([0,4], self, :black)
    @rows[0][5] = Bishop.new([0,5], self, :black)
    @rows[0][6] = Knight.new([0,6], self, :black)
    @rows[0][7] = Rook.new([0,7], self, :black)
    @rows[1].map.with_index do |space,index|
      space = Pawn.new([1, index], self, :black)
    end

    @rows[6].map.with_index do |space,index|
      space = Pawn.new([1, index], self, :white)
    end
    @rows[0][0] = Rook.new([0,0], self, :white)
    @rows[0][1] = Knight.new([0,1], self, :white)
    @rows[0][2] = Bishop.new([0,2], self, :white)
    @rows[0][3] = Queen.new([0,3], self, :white)
    @rows[0][4] = King.new([0,4], self, :white)
    @rows[0][5] = Bishop.new([0,5], self, :white)
    @rows[0][6] = Knight.new([0,6], self, :white)
    @rows[0][7] = Rook.new([0,7], self, :white)
  end

  def occupant(pos)
    x,y = pos
    if @rows[x][y].nil?
      return nil
    else
      return @rows[x][y].color
    end
  end
end