require_relative("card")
require "byebug"

class Board

  def initialize(size)
    @grid = Array.new(size) {Array.new(size)}
    @cards = []
    @dashes = "\n--" + ("-" * (size * 4))
    self.populate
  end

  def [](pos_arr)
    @grid[pos_arr[0]][pos_arr[1]]
  end

  def []=(pos_arr, card)
    @grid[pos_arr[0]][pos_arr[1]] = card
  end

  def populate
    total_pairs = (@grid.length * @grid.length) / 2
    while @cards.length < (total_pairs * 2)
      pair = Card.make_random_pair
      @cards.concat(pair) if !@cards.include?(pair[0])
    end
    shuffled_cards = @cards.shuffle
    (0...@grid.length).each do |idx|
      (0...@grid.length).each do |i|
        self[[idx, i]] = shuffled_cards.pop
      end
    end
  end

  def render
    system "clear"
    puts "  Memory Puzzle v4.0"
    print "\n "
    (1..@grid.length).each { |i| print " | #{i}" }
    print @dashes
    @grid.each_with_index do |row, i| 
        print "\n#{i+1} "
      row.each do |card| 
          print "| #{card} " 
      end
      print @dashes
    end
    puts
  end

  def won?
    @cards.all? { |card| card.face_up? }
  end

  def valid_guess?(pos)
    return false if pos.length < 2
    if (pos[0] >= 0 && pos[0] < @grid.length) && (pos[1] >= 0 && pos[1] < @grid.length)
        return false if self[pos].face_up?
        return true
    end
    false
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new(6)
  board.render
  p board.valid_guess?([0,0])
  p board.valid_guess?([8,0])
  p board.won?
end