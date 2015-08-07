require_relative 'card'
class Deck

  attr_reader :cards

  def initialize
    populate_full_deck
  end

  def count
    cards.count
  end

  def populate_full_deck
    @cards = []
    Card.values.each do |value|
      Card.suits.each do |suit|
        @cards << Card.new(value, suit)
      end
    end
  end

  def take(n)
    cards.pop(n)
  end

  def shuffle
    cards.shuffle!
  end



end
