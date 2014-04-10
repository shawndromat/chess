require './piece.rb'
require 'colorize'


class Pawn < Piece
  attr_reader :direction

  SPRITE = "\u265f "

  def initialize(position, board, color)
    super(position, board, color)
    @direction = (@color == :black ? 1 : -1)
    @strike_deltas = [
      [@direction * 1, -1],
      [@direction * 1, 1]
    ]
  end

  def moves
    list_of_moves = []

    if first_move?
      two_forward = [@position[0] + (@direction * 2), @position[1]]
      list_of_moves << two_forward if @board.occupant(two_forward) == nil
    end

    one_forward = [@position[0] + (@direction * 1), @position[1]]
    list_of_moves << one_forward if @board.occupant(one_forward) == nil

    @strike_deltas.each do |delta|
      x, y = @position[0] + delta[0], @position[1] + delta[1]
      if on_board?([x, y]) && opponent?([x, y])
        list_of_moves << [x, y]
      end
    end

    list_of_moves
  end

  def first_move?
    if @position[0] == 1 && @color == :black
      return true
    elsif @position[0] == 6 && @color == :white
      return true
    end
    false
  end
end