require './board.rb'
require 'yaml'
require 'colorize'
require 'io/console'


class Chess
  attr_reader :player1, :player2
  attr_accessor :board, :current_player, :opposite_player, :cursor,
  :cursor_start_position, :cursor_end_position

  def initialize
    @start_pos = nil
    @end_pos = nil
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
    @player1 = Player.new(:white, name)
    puts "Enter second player's name:"
    name = gets.chomp
    @player2 = Player.new(:black, name)
  end

  def play
    welcome_sequence

    @current_player ||= @player1
    @opposite_player ||= @player2
    @cursor = [7,0]

    until over?(@current_player)
      player_move
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

  def player_move
    error_message = ""
    begin
      @start_pos = nil
      @end_pos = nil
      while @end_pos == nil
        @board.display(@cursor, @start_pos)
        puts "#{@current_player.name}'s turn."
        puts error_message
        puts "You're in check" if @board.in_check?(@current_player.color)

        get_move
      end
      @board.move(@start_pos, @end_pos)
    rescue InvalidMoveError => e
      puts "errored out"
      puts e.message
      retry
    end
  end

  def get_move
    begin
      move = $stdin.getch.downcase

      first, last = @cursor
      case move
        when 'w'
          @cursor = [first - 1, last] unless first == 0
        when 's'
          @cursor = [first + 1, last] unless first == 7
        when 'a'
          @cursor = [first, last - 1] unless last == 0
        when 'd'
          @cursor = [first, last + 1] unless last == 7
        when 'n'
          save_game
        when 'q'
          exit
        when ' '
          select_piece
        else
          raise WrongKeyError.new
        end
    rescue WrongKeyError
      puts "Use 'w', 'a', 's' and 'd' to move"
      retry
    rescue InvalidEntryError => e
      puts e.message
      retry
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def select_piece
    #if no start position yet, make selected piece start position
    if @start_pos.nil?
      if @board[@cursor].nil?
        raise InvalidEntryError.new "There's no piece there."
      end
      if @board[@cursor].color != @current_player.color
        raise InvalidEntryError.new "That is not your piece"
      end
      @start_pos = @cursor
    else
      #already a start position so set end position
      @end_pos = @cursor
    end
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

class SavingError < StandardError
end

class WrongKeyError < StandardError
end

class InvalidMoveError < StandardError
end

class InvalidEntryError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  g = Chess.new
  g.play


end