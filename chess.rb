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
    until over?
      @board.display
      get_turn(current_player)

      current_player, opposite_player = opposite_player, current_player

    end
  end

  def parse_get_turn_input(player)
    puts "Enter turn:"
    user_input = gets.chomp.split(", ")
    if user_input.length != 2
      raise RuntimeError.new "Not a valid move! Must have 2 tiles selected."
    end
    user_input
  end

  def get_turn(player)
    begin
      start_pos, end_pos = parse_get_turn_input(player)
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
    [ (8 - number.to_i), letters[ letter.to_sym ] ]
  end

  #if saved, go straight to game loop

  #loop
  #display
  #get the players move // #save game
  #move
  #check for check and checkmate
end

class Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

end

class HumanPlayer < Player

end

class ComputerPlayer < Player

end

if __FILE__ == $PROGRAM_NAME
  puts "chess"
  g = Chess.new
  g.play


end