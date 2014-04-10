Dir["./*.rb"].each {|file| require file }
require 'colorize'

class Board
  attr_reader :rows

  def initialize(start_board = true)
    @rows  = Array.new(8) { Array.new(8) }
    set_pieces if start_board
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
      @rows[6][index] = Pawn.new([6, index], self, :white)
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

  def [](pos)
    x, y = pos
    @rows[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end

  def checkmate?(color)
    no_valid_moves?(color) && in_check?(color)
  end

  def stalemate?(color)
    no_valid_moves?(color) && !in_check?(color)
  end

  def no_valid_moves?(color)
    @rows.each do |row|
      row.each do |tile|
        next if tile.nil?
        return false if tile.color == color && tile.valid_moves.length > 0
      end
    end
    true
  end

  def move(start_pos, end_pos)
    current_piece = self[start_pos]
    raise "Not a valid move!" unless current_piece.valid_moves.include?(end_pos)
    p current_piece.position
    current_piece.position = end_pos
    self[end_pos] = current_piece
    pawn_promotion(end_pos)
    self[start_pos] = nil
  end

  def test_move(start_pos, end_pos)
    current_piece = self[start_pos]
    raise "Not a valid move!" unless current_piece.moves.include?(end_pos)
    current_piece.position = end_pos
    self[end_pos] = current_piece
    self[start_pos] = nil
  end

  def display(cursor_pos = nil, cursor_start = nil)
    system("clear")
    puts
    counter = 0
    @rows.each_with_index do |row, row_idx|
      print " #{8 - row_idx} "
      row.each_with_index do |tile, col_idx|
        counter += 1
        sprite = tile.nil?  ? "  " : "#{tile.get_sprite}"
        sprite = sprite.on_cyan if counter.odd?
        sprite = sprite.on_yellow if counter.even?
        sprite = sprite.on_magenta.blink if [row_idx, col_idx] == cursor_start
        sprite = sprite.on_red.blink if [row_idx, col_idx] == cursor_pos
        print sprite
      end
      counter += 1
      puts
    end
    print "   "
    ('A'..'H').each { |letter| print "#{letter} "}
    puts
    nil
  end

  def dup
    dup_board = Board.new(false)
    @rows.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        dup_board[[idx1, idx2]] = tile.piece_dup(dup_board) unless tile.nil?
      end
    end
    dup_board
  end

  def pawn_promotion(pos)
    return unless self[pos].class == Pawn
    if self[pos].position[0] == 0 && self[pos].color == :white
      self[pos] = Queen.new(pos, self, :white)
    elsif self[pos].position[7] == 0 && self[pos].color == :black
      self[pos] = Queen.new(pos, self, :black)
    end
  end
end