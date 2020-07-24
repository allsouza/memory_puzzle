require "byebug"
class Card

    DECK = (:A..:Z).to_a

    def self.make_random_pair
        face = DECK.sample
        card1 = Card.new(face)
        card2 = Card.new(face)
        [card1, card2]
    end
    
    attr_reader :face_value

    def initialize(face_value)
        @face_value = face_value
        @face_up = false
    end

    def face_up?
        @face_up
    end

    def hide
        @face_up = false
    end

    def reveal
        @face_up = true
    end

    def ==(card)
        self.face_value == card.face_value
    end

    def to_s
        self.face_up? ? "#{self.face_value}" : " "
    end
    
end