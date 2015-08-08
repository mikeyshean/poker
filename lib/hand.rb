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
  
  def evaluate_hand
    find_straight_flush ||
    find_quads ||
    find_full_house ||
    find_flush ||
    find_straight ||
    find_trips ||
    find_pairs(:two_pair) ||
    find_pairs(:pair) 
  end
    
  def find_pairs(rank)
    card_count = Hash.new { |h,k| h[k] = 0 }

    cards.each { |card| card_count[card.poker_value] += 1 }
    pairs = card_count.select { |_, count| count == 2 }.keys.uniq

    return nil unless pairs.count == HAND_RANK[rank]
    set_value(rank, pairs)
  end

  def find_trips
    card_count = Hash.new { |h,k| h[k] = 0 }

    cards.each { |card| card_count[card.poker_value] += 1 }
    trips = card_count.select { |_, count| count == 3 }.keys.uniq

    return nil unless trips.count == 1
    set_value(:trips, trips)
  end

  def find_quads
    card_count = Hash.new { |h,k| h[k] = 0 }

    cards.each { |card| card_count[card.poker_value] += 1 }
    quads = card_count.select { |_, count| count == 4 }.keys.uniq

    return nil unless quads.count == 1
    set_value(:quads, quads)
  end
  
  def find_full_house
    return nil unless find_pairs(:pair) && find_trips
    self.value[:rank] = HAND_RANK[:full_house]
    value
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
  
  def find_straight_flush
    return nil unless find_flush && find_straight
    made_hand = cards.map(&:poker_value).sort
    set_value(:straight_flush, made_hand)
  end


  def set_value(rank, made_cards)
    case rank
    when :pair, :trips, :quads
      kickers = cards.map(&:poker_value)
      .reject { |value| value == made_cards[0]}
    when :two_pair
      kickers = cards.map(&:poker_value)
      .find { |value| !made_cards.include?(value)}
    end
    
    self.value[:rank] = HAND_RANK[rank]
    self.value[:made_cards] = made_cards
    self.value[:kicker_cards] = kickers
    self.value
  end



  def beats?(other_hand)
    evaluate_hand
    other_hand.evaluate_hand
    case value[:rank] <=> other_hand.value[:rank]
    when -1
      false
    when 0
      tie_breaker(other_hand)
    when 1
      true
    end
  end

  def tie_breaker(other_hand)
    return nil if value.keys.all? { |key| value[key] == other_hand.value[key] }
    
    made_cards.count.times do |pos|
      case made_cards[pos] <=> other_hand.made_cards[pos]
      when -1
        return false
      when 0
        next
      when 1
       return true
      end
    end
    
    kicker_cards.count.times do |pos|
      case kicker_cards[pos] <=> other_hand.kicker_cards[pos]
      when -1
        return false
      when 0
        next
      when 1
       return true
      end
    end
    nil
  end

  
  def made_cards
    value[:made_cards].reverse
  end
  
  def kicker_cards
    value[:kicker_cards].reverse
  end



end
