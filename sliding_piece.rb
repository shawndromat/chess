require './piece.rb'

class SlidingPiece < Piece



  def moves
    possible_moves = []

    if move_dirs(:diagonal)
      until another piece || !on_board?(pos)
        possible_moves << pos


    if move_dirs(:horizontal)
      until another piece || !on_board?
        possible_moves << pos
    #in your possible directions, expand til another piece blocks you, or end of board

    #if move_dirs diagonal add all [x-1,y+1]
    #if move_dirs horizontal add all [x, y + n] and [x + n, y]


    #return array of move positions?
    possible_moves
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