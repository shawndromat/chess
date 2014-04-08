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
        all_moves << expand_moves(DIAG_DELTAS, @position)
      end
      if move_dirs.include?(:horizontal)
        all_moves << expand_moves(HORIZ_DELTAS, @position)
      end
    end
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:horizontal]
  end
end

class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :horizontal]
  end
end