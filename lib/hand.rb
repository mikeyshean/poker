class Hand

  attr_reader :cards

  def initialize(cards = [])
    @cards = cards
  end

  def num_pairs
    pair_count = 0
    Card.values.each do |value|
      pair_count += 1 if cards.count{|card| card.value == value} == 2
    end
    pair_count
  end

  def has_trips?
    Card.values.each do |value|
      return true if cards.count{|card| card.value == value} == 3
    end
    false
  end

  def has_quads?
    Card.values.each do |value|
      return true if cards.count{|card| card.value == value} == 4
    end
    false
  end

end
