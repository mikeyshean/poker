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

  def flush?
    suit = cards.first.suit
    cards.all? { |card| card.suit == suit }
  end

  def full_house?
    num_pairs == 1 && has_trips?
  end

  def straight?
    values = cards.map(&:poker_value).sort
    values == (values.first .. values.last).to_a  ||  values == [2,3,4,5,14]
  end

  def straight_flush?
    straight? && flush?
  end

  def hand_value
    return 8 if straight_flush?
    return 7 if has_quads?
    return 6 if full_house?
    return 5 if flush?
    return 4 if straight?
    return 3 if has_trips?
    return 2 if num_pairs == 2
    return 1 if num_pairs == 1
    0
  end

  def beats?(other_hand)
    hand_value > other_hand.hand_value
  end



end
