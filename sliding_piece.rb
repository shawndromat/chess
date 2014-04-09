require './piece.rb'


class SlidingPiece < Piece

  DIAG_DELTAS = [
    [-1, -1],
    [-1, 1],
    [1, 1],
    [1, -1]
  ]

  HORIZ_DELTAS = [
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0]
  ]

  def expand_moves(deltas)
    [].tap do |possible_moves|
      deltas.each do |delta|
        pos = [@position[0] + delta[0], @position[1] + delta[1]]
        while on_board?(pos) && (@board.occupant(pos) != @color)
          possible_moves << pos
          break if opponent?(pos)
          pos = [pos[0] + delta[0], pos[1] + delta[1]]
        end
      end
    end
  end

  def moves
    [].tap do |all_moves|
      if move_dirs.include?(:diagonal)
        expand_moves(DIAG_DELTAS).each do
          |x| all_moves << x # unless move_into_check?(x)
        end
      end
      if move_dirs.include?(:horizontal)
        expand_moves(HORIZ_DELTAS).each do
          |x| all_moves << x # unless move_into_check?(x)
        end
      end
    end.select { |move| !move_into_check?(move)}
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end

  def get_sprite
    @color == :black ? "\u265D" : "\u2657"
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:horizontal]
  end

  def get_sprite
    @color == :black ? "\u265C" : "\u2656"
  end
end

class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :horizontal]
  end

  def get_sprite
    @color == :black ? "\u265B" : "\u2655"
  end
end