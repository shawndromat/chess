Dir["./*.rb"].each {|file| require file }
require 'colorize'

class Board
  attr_reader :rows

  def initialize(start_board = true)
    @rows  = Array.new(8) { Array.new(8) }
    set_pieces if start_board
  end

  def set_pieces
    place_big_pieces(0, :black)
    place_pawns(1, :black)
    place_pawns(6, :white)
    place_big_pieces(7, :white)
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
    king = find_king(color)
    @rows.each do |row|
      row.each do |tile|
        if (tile != nil) && (tile.color != king.color)
          return true if tile.moves.include?(king.position)
        end
      end
    end
    false
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

  def move(start_pos, end_pos)
    current_piece = self[start_pos]
    unless current_piece.valid_moves.include?(end_pos)
      raise InvalidMoveError.new "Not a valid move!"
    end
    place_piece(start_pos, end_pos)

  end

  def test_move(start_pos, end_pos)
    current_piece = self[start_pos]
    unless current_piece.moves.include?(end_pos)
      raise InvalidMoveError.new "Not a valid move!"
    end
    place_piece(start_pos, end_pos)
  end

  def display(cursor_pos = nil, cursor_start = nil)
    system("clear")
    puts
    @rows.each_with_index do |row, row_idx|
      print " #{8 - row_idx} "
      row.each_with_index do |tile, col_idx|
        sprite = tile.nil?  ? "  " : "#{tile.get_sprite}"
        sprite = sprite.on_cyan if (row_idx + col_idx).odd?
        sprite = sprite.on_yellow if (row_idx + col_idx).even?
        sprite = sprite.on_magenta.blink if [row_idx, col_idx] == cursor_start
        sprite = sprite.on_red.blink if [row_idx, col_idx] == cursor_pos
        print sprite
      end.join("")
      puts
    end
    print "   "
    ('A'..'H').each { |letter| print "#{letter} "}
    puts
    nil
  end

  private
  def place_big_pieces(row, color)
    @rows[row][0] = Rook.new([row,0], self, color)
    @rows[row][1] = Knight.new([row,1], self, color)
    @rows[row][2] = Bishop.new([row,2], self, color)
    @rows[row][3] = Queen.new([row,3], self, color)
    @rows[row][4] = King.new([row,4], self, color)
    @rows[row][5] = Bishop.new([row,5], self, color)
    @rows[row][6] = Knight.new([row,6], self, color)
    @rows[row][7] = Rook.new([row,7], self, color)
  end

  def place_pawns(row, color)
    (0..7).each do |index|
      @rows[row][index] = Pawn.new([row, index], self, color)
    end
  end

  def find_king(color)
    @rows.each do |row|
      row.each do |tile|
        if (tile.class == King) && (tile.color == color)
          return tile
        end
      end
    end
  end

  def pawn_promotion(pos)
    return unless self[pos].class == Pawn
    if self[pos].position[0] == 0 && self[pos].color == :white
      self[pos] = Queen.new(pos, self, :white)
    elsif self[pos].position[7] == 0 && self[pos].color == :black
      self[pos] = Queen.new(pos, self, :black)
    end
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

  def place_piece(start_pos, end_pos)
    current_piece = self[start_pos]
    current_piece.position = end_pos
    self[end_pos] = current_piece
    self[start_pos] = nil
    pawn_promotion(end_pos)
  end
end