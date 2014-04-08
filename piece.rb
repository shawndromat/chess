class Piece
  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def moves
    raise NotImplementedError
  end

  def opponent?(pos)
    return false if @board.row[pos[0]][pos[1]].nil?
    @color != @board.row[pos[0]][pos[1]].color
  end

  def on_board?(pos)
    pos.all? { |coord| (0...8).cover?(coord) }
  end
end