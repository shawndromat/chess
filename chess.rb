require './board.rb'

class Chess
  attr_reader :player1, :player2
  attr_accessor :board


  def initialize
  end

  def welcome_sequence
    #choose new or saved game
    set_players
    @board = Board.new
    #if new, choose player types
  end

  def set_players
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)
  end

  def play
    welcome_sequence

    current_player = @player1
    opposite_player = @player2

    until over?(current_player)
      @board.display
      puts "#{current_player.name}'s turn."
      make_move(current_player)
      current_player, opposite_player = opposite_player, current_player
    end

    @board.display

    if @board.checkmate?(current_player.color)
      puts "#{current_player.name} was checkmated by #{opposite_player.name}."
      puts "#{current_player.name} loses."
    else
      puts "Stalemate!"
    end
  end

  def over?(player)
    @board.checkmate?(player.color) || @board.stalemate?(player.color)
  end

  def parse_input(player)
    puts "Enter turn:"
    user_input = gets.chomp.split(", ")
    if user_input.length != 2
      raise RuntimeError.new "Not a valid move! Must have 2 tiles selected."
    end
    user_input
  end

  def get_turn(player)
    begin
      start_pos, end_pos = parse_input(player)
    rescue RuntimeError => e
      puts e.message
      retry
    end

    move = [translate_input(start_pos.split("")), translate_input(end_pos.split(""))]

    if @board[move[0]].nil?
      raise RuntimeError.new "There's no piece on that tile."
    end
    if @board[move[0]].color != player.color
      raise RuntimeError.new "That piece isn't yours!"
    end
    move
  end

  def make_move(player)
    begin
      start_pos, end_pos = get_turn(player)
      @board.move(start_pos, end_pos)
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def translate_input(pos)
    letters = {
      a: 0,
      b: 1,
      c: 2,
      d: 3,
      e: 4,
      f: 5,
      g: 6,
      h: 7
    }
    letter, number = pos

    unless ('1'..'8').cover?(number) and ('a'..'h').cover?(letter)
      raise RuntimeError.new "Please enter your move in this format: f3, f4"
    end

    [ (8 - number.to_i), letters[ letter.downcase.to_sym ] ]
  end

end

class Player

  attr_reader :color, :name

  def initialize(color, name = nil)
    @color = color
    @name ||= (color == :white ? "Player 1" : "Player 2")
  end

end

class HumanPlayer < Player

end

class ComputerPlayer < Player

end

if __FILE__ == $PROGRAM_NAME
  g = Chess.new
  g.play


end