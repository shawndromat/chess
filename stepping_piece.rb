require './piece.rb'
require 'colorize'

class SteppingPiece < Piece

  def moves
    [].tap do |list_of_moves|
      self.class::DELTAS.each do |delta|
        x, y = @position[0] + delta[0], @position[1] + delta[1]
        if on_board?([x, y]) && (@board.occupant([x,y]) != @color)
          list_of_moves << [x, y]
        end
      end
    end
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

  SPRITE = "\u265e "
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

  SPRITE = "\u265A "
end