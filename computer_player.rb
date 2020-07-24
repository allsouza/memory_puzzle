require "byebug"

class ComputerPlayer
    
  attr_reader :name, :score, :count

  def initialize(size, difficulty = 2)
    @name = "Computer"
    @difficulty = difficulty
    @score = 0
    @known_cards = Hash.new {|h, k| h[k] = []}
    @pair_guesses = []
    @count = 0
    @possible_guesses = []
    @bad_combos = []
    @combination = []
    (0...size).each do |x|
        (0...size).each { |y| @possible_guesses << [x,y] }
    end
  end

  def eliminate_guesses(pos1, pos2)
    @possible_guesses.reject! { |arr| arr == pos1 || arr == pos1 }
  end

  def inc
    @count += 1
  end

  def bad_combo?(pos1, pos2)
    @bad_combos.include?([pos1, pos2]) || @bad_combos.include?([pos2, pos1]) 
  end

  def add_bad_combo(arr)
    @bad_combos << arr
  end

  def reset
    @count = 0
    @combination = []
  end

  def get_guess
    case (1..@difficulty).to_a.sample
    when 1
      if self.guess_pair || !@pair_guesses.empty?
          @pair_guesses.pop
      else
        pos = self.random_pos
        if @combination.empty?
            pos
        else
            while self.bad_combo?(pos, @combination[0])
              pos = self.random_pos
            end
            pos
        end
      end
    else
      self.random_pos
    end
  end

  def random_pos
    @possible_guesses.sample
  end

  def guess_pair
    @known_cards.each do |k, v| 
      if v.length == 2 #we have both positions
        @pair_guesses += @known_cards.delete(k)
        true
      end
    end
    false
  end

  def add_point
    @score += 1
  end

  def save_card(card, position)
    @known_cards[card.face_value] << position if !@known_cards[card.face_value].include?(position)
  end

end