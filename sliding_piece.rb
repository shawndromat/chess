require './piece.rb'
require 'colorize'

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

  def moves
    [].tap do |all_moves|
      if move_dirs.include?(:diagonal)
        expand_moves(DIAG_DELTAS).each do
          |x| all_moves << x
        end
      end
      if move_dirs.include?(:horizontal)
        expand_moves(HORIZ_DELTAS).each do
          |x| all_moves << x
        end
      end
    end
  end

  private
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
end

class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end

  SPRITE = "\u265D "
end

class Rook < SlidingPiece
  def move_dirs
    [:horizontal]
  end

  SPRITE = "\u265C "
end

class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :horizontal]
  end

  SPRITE = "\u265B "
end