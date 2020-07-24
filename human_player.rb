class HumanPlayer
  attr_reader :name, :score

  def initialize(name)
    @name = name
    @score = 0
  end

  def get_guess
        print "\nEnter a guess in the format \"2 2\": "
        gets.chomp.split.map{ |num| num.to_i - 1 }
  end

  def add_point
    @score += 1
  end
end