require 'debugger'
require './board.rb'

class Piece
  attr_reader :position, :color, :board

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def moves
    raise NotImplementedError
  end

  def opponent?(pos)
    return false if @board.rows[pos[0]][pos[1]].nil?
    @color != @board.rows[pos[0]][pos[1]].color
  end

  def on_board?(pos)
    pos.all? { |coord| (0...8).cover?(coord) }
  end

  def inspect
    "#{@color} #{self.class} pos: #{@position} moves: #{moves}"
  end

  # def move_into_check?(target_pos)
#     dup_board = @board.dup
#     dup_board.move(@position, target_pos)
#     return true if dup_board.in_check?(@color)
#     false
#   end

  def piece_dup(new_board)
    self.class.new(@position.dup, new_board, @color)
  end

end