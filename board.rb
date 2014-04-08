Dir['./*.rb'].each { |file| require file }

class Board
  attr_reader :rows

  def initialize
    @rows  = Array.new(8) {Array.new(8)}
    set_pieces
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
    (0..7).each do |index|
      @rows[1][index] = Pawn.new([1, index], self, :black)
    end

    (0..7).each do |index|
      @rows[6][index] = Pawn.new([1, index], self, :white)
    end
    @rows[7][0] = Rook.new([7,0], self, :white)
    @rows[7][1] = Knight.new([7,1], self, :white)
    @rows[7][2] = Bishop.new([7,2], self, :white)
    @rows[7][3] = Queen.new([7,3], self, :white)
    @rows[7][4] = King.new([7,4], self, :white)
    @rows[7][5] = Bishop.new([7,5], self, :white)
    @rows[7][6] = Knight.new([7,6], self, :white)
    @rows[7][7] = Rook.new([7,7], self, :white)
  end

  def occupant(pos)
    x,y = pos
    if @rows[x][y].nil?
      return nil
    else
      return @rows[x][y].color
    end
  end

  def in_check?(color)
    king = nil
    @rows.each do |row|
      row.each do |tile|
        if (tile.class == King) && (tile.color == color)
          king = tile
        end
      end
    end

    @rows.each do |row|
      row.each do |tile|
        if (tile != nil) && (tile.color != king.color)
          return true if tile.moves.include?(king.position)
        end
      end
    end
    false
  end

  def move(start_pos, end_pos)

  end

  def display
    system("clear")
    puts
    @rows.each_with_index do |row, index|
      print " #{8 - index} "
      row.each do |tile|
        print tile.nil?  ? "   " : " #{tile.get_sprite}"
      end
      puts
    end
    print "   "
    ('A'..'H').each { |letter| print " #{letter}"}
    nil
  end
end