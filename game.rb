require_relative "./board.rb"
require_relative "./human_player.rb"
require_relative "./computer_player.rb"

class Game

    def initialize(size, player_name, difficulty)
        size = 4 if ![2, 4, 6].include?(size)
        @board = Board.new(size)
        @player_1 = HumanPlayer.new(player_name)
        @comp_player = ComputerPlayer.new(size, difficulty)
        @current_player = @player_1
    end

    def play
        until @board.won?
            self.turn
        end
        self.print_board
        if @player_1.score >= @comp_player.score
            puts "\nYou win!"
        else
            puts "\nYou LOSE!"
        end
    end

    def print_board
        @board.render
        puts "\n     Score Board \n\n#{@player_1.name}: #{@player_1.score} vs #{@comp_player.name}: #{@comp_player.score}"
    end

    def turn
        self.print_board
        card1 = self.get_card
        card1[0].reveal
        self.print_board
        card2 = self.get_card
        card2[0].reveal
        self.print_board
        @comp_player.reset
        if card1[0] != card2[0]
            puts "\nTry again"
            sleep(3)
            card1[0].hide
            card2[0].hide
            @comp_player.add_bad_combo([card1[1],card2[1]])
            self.switch_player
        else 
            self.print_board
            puts "\nIt's a match!"
            @current_player.add_point
            @comp_player.eliminate_guesses(card1[1],card2[1])
            sleep(1.5)
        end
    end

    def get_card 
        position = []
        until @board.valid_guess?(position)
            position = @current_player.get_guess
        end
        @comp_player.save_card(@board[position], position)
        @comp_player.inc if @current_player == @comp_player
        [@board[position] , position] #need to return position for AI purposes
    end

    def switch_player
        if @current_player == @player_1
            @current_player = @comp_player
        else
            @current_player = @player_1
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    system "clear"
    puts "Welcome to the Memory Puzzle!"
    print "\nPlease enter grid size: "
    size = gets.chomp.to_i
    print "\nPlease enter difficulty (1-GOD MODE | 2-MEDIUM | 3-EASY): "
    difficulty = gets.chomp.to_i
    print "\nPlease enter your name: "
    name = gets.chomp
    game = Game.new(size, name, difficulty)
    game.play
end