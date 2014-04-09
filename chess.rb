require './board.rb'
require 'yaml'
require 'colorize'


class Chess
  attr_reader :player1, :player2
  attr_accessor :board, :current_player, :opposite_player

  def initialize
  end

  def welcome_sequence
    system("clear")
    puts "Welcome to the Ultimate Chess Simulator\n"
    puts "Would you like to load a saved game or start a new game?"
    puts 'Enter "L" or "N":'
    user_input = gets.chomp.downcase
    if user_input == 'n'
      set_players
      @board = Board.new
    elsif user_input == 'l'
      puts "Please enter the saved game you'd like to load:"
      load_game = gets.chomp.downcase
      game_file = File.read("saved_games/#{load_game}.yml")
      game = YAML::load(game_file)
      @board = game.board
      @current_player = game.current_player
      @opposite_player = game.opposite_player
    else
      welcome_sequence
    end
    #if new, choose player types
  end

  def set_players
    puts "Enter first player's name:"
    name = gets.chomp
    @player1 = HumanPlayer.new(:white, name)
    puts "Enter second player's name:"
    name = gets.chomp
    @player2 = HumanPlayer.new(:black, name)
  end

  def play
    welcome_sequence

    @current_player ||= @player1
    @opposite_player ||= @player2

    until over?(@current_player)
      @board.display
      puts "#{@current_player.name}'s turn."
      make_move(@current_player)
      @current_player, @opposite_player = @opposite_player, @current_player
    end

    @board.display

    if @board.checkmate?(current_player.color)
      puts "#{@current_player.name} was checkmated by #{@opposite_player.name}."
      puts "#{@current_player.name} loses."
    else
      puts "Stalemate!"
    end
  end

  def over?(player)
    @board.checkmate?(player.color) || @board.stalemate?(player.color)
  end

  def parse_input(player)
    puts "Enter 'save' at any time to save game."
    puts "Enter move:"
    user_input = gets.chomp
    raise SavingError.new "Saving game" if user_input.downcase == "save"
    user_input = user_input.split(",").map(&:strip)
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
    rescue SavingError
      save_game
      puts "Thanks for playing!"
      sleep(1)
      exit
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

  def save_game
    puts "Please enter a name for your saved game:"
    filename = gets.chomp.downcase
    File.open("saved_games/#{filename}.yml", 'w') do |f|
      f.puts self.to_yaml
    end
  end
end

class Player

  attr_reader :color, :name

  def initialize(color, name = nil)
    @color = color
    @name = name || (color == :white ? "Player 1" : "Player 2")
  end

end

class HumanPlayer < Player

end

class ComputerPlayer < Player

end

class SavingError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  g = Chess.new
  g.play


end