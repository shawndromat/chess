require './piece.rb'

class SteppingPiece < Piece

  def moves
    [].tap do |list_of_moves|
      self.class::DELTAS.each do |delta|
        x, y = @position[0] + delta[0], @position[1] + delta[1]
        if on_board?([x, y]) && (@board.occupant([x,y]) != @color)
          list_of_moves << [x, y]
        end
      end
    end.select { |move| !move_into_check?(move)}
  end
end

class Knight < SteppingPiece

  DELTAS = [
    [-1, 2],
    [1, 2],
    [-1, -2],
    [1, -2],
    [2, -1],
    [2, 1],
    [-2, -1],
    [-2, 1]
  ]

  def get_sprite
    @color == :black ? "\u265e" : "\u2658"
  end

end

class King < SteppingPiece
  DELTAS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, 1],
    [0, -1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

  def get_sprite
    @color == :black ? "\u265A" : "\u2654"
  end
end