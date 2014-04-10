require './board.rb'
require 'yaml'
require 'colorize'
require 'io/console'


class Chess
  attr_reader :player1, :player2
  attr_accessor :board, :current_player, :opposite_player, :cursor,
  :cursor_start_position, :cursor_end_position

  def initialize
    @cursor_start_position = nil
    @cursor_end_position = nil
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
    @cursor = [7,0]

    until over?(@current_player)
      get_move
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

  def get_cursor_input
    key = $stdin.getch.downcase
    return :up if key == 'w'
    return :down if key == 's'
    return :left if key == 'a'
    return :right if key == 'd'
    return :space if key == ' '
    save_game if key == 'p'
    exit if key == '0'
  end

  def get_move
    error_message = ""
    begin

    while true
      x, y = @cursor

      @board.display(@cursor, @cursor_start_position)
      puts "#{@current_player.name}'s turn."
      puts error_message
      puts "You're in check" if @board.in_check?(@current_player.color)

      key = get_cursor_input
      error_message = ""
      if key == :up
        @cursor = [x - 1, y] unless x == 0
      elsif key == :down
        @cursor = [x + 1, y] unless x == 7
      elsif key == :left
        @cursor = [x, y - 1] unless y == 0
      elsif key == :right
        @cursor = [x, y + 1] unless y == 7
      elsif key == :space
        if @cursor_start_position.nil?
          @cursor_start_position = [x, y] if @board[@cursor] != nil
        else
          @cursor_end_position = [x, y]
          make_move
          @cursor_start_position = nil
          @cursor_end_position = nil
          break
        end
      end
    end

    rescue RuntimeError => e
      @cursor_start_position = nil
      @cursor_end_position = nil
      error_message = e.message
      retry
    end

  end

  def make_move
    if @board[@cursor_start_position].color != @current_player.color
      raise RuntimeError.new "That piece isn't yours!"
    end
    if @board[@cursor_start_position].nil?
      raise RuntimeError.new "There's no piece on that tile."
    end
    @board.move(@cursor_start_position, @cursor_end_position)
  end

  def save_game
    puts "Please enter a name for your saved game:"
    filename = gets.chomp.downcase
    File.open("saved_games/#{filename}.yml", 'w') do |f|
      f.puts self.to_yaml
    end
    exit
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