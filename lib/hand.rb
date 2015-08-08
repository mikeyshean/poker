class Hand

  attr_reader :cards
  attr_accessor :value

  HAND_RANK = {
    :straight_flush => 8,
    :quads          => 7,
    :full_house     => 6,
    :flush          => 5,
    :straight       => 4,
    :trips          => 3,
    :two_pair       => 2,
    :pair           => 1,
    :high_card      => 0
  }

  ACE_LOW = [1,2,3,4,5]

  def initialize(cards = [])
    @cards = cards
    @value = {}
  end

  def find_pairs(rank)
    card_count = Hash.new { |h,k| h[k] = 0 }

    cards.each { |card| card_count[card.poker_value] += 1 }
    pairs = card_count.select { |_, count| count == 2 }

    return nil unless pairs.count == HAND_RANK[rank]
    set_value(rank, pairs)
  end

  def find_trips
    card_count = Hash.new { |h,k| h[k] = 0 }

    cards.each { |card| card_count[card.poker_value] += 1 }
    trips = card_count.select { |_, count| count == 3 }

    return nil unless trips.count == 1
    set_value(:trips, trips)
  end

  def find_quads
    card_count = Hash.new { |h,k| h[k] = 0 }

    cards.each { |card| card_count[card.poker_value] += 1 }
    quads = card_count.select { |_, count| count == 4 }

    return nil unless quads.count == 1
    set_value(:quads, quads)
  end

  def find_straight
    card_values = cards.map(&:poker_value).sort

    if card_values == (card_values.first..card_values.last).to_a
      set_value(:straight, card_values)
    elsif card_values == [2,3,4,5,14]
      set_value(:straight, ACE_LOW)
    else
      return nil
    end
  end
  
  def find_flush
    return nil unless cards.map(&:suit).uniq.length == 1
    made_hand = cards.map(&:poker_value).sort
    set_value(:flush, made_hand)
  end


  def set_value(rank, made_cards = self.cards)
    case rank
    when :pair, :trips, :quads
      made_cards_value = made_cards.keys[0]

      self.value[:rank] = HAND_RANK[rank]
      self.value[:made_cards] = [made_cards_value]
      self.value[:kicker_cards] = cards.map(&:poker_value)
      .reject { |value| value == made_cards_value}
    when :two_pair
      pair_value = made_cards.keys

      self.value[:rank] = HAND_RANK[rank]
      self.value[:made_cards] = pair_value
      self.value[:kicker_cards] = cards.map(&:poker_value)
      .find { |value| !pair_value.include?(value)}
    when :straight, :flush
      self.value[:rank] = HAND_RANK[rank]
      self.value[:made_cards] = made_cards
    end
    self.value
  end





  def beats?(other_hand)
    case hand_value <=> other_hand.hand_value
    when 1
      true
    when -1
      false
    when 0
      tie_breaker(other_hand)
    end
  end

  def tie_breaker(other_hand)

  end



end
#
