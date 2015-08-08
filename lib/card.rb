
class Card
  attr_reader :value, :suit

  POKER_VALUES = {
    :two => 2,
    :three => 3,
    :four => 4,
    :five => 5,
    :six => 6,
    :seven => 7,
    :eight => 8,
    :nine => 9,
    :ten => 10,
    :jack => 11,
    :queen => 12,
    :king => 13,
    :ace => 14
  }
  

  SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def self.values
    POKER_VALUES.keys
  end

  def self.suits
    SUIT_STRINGS.keys
  end

  def poker_value
    POKER_VALUES[value]
  end

  def same_suit?(other_card)
    suit == other_card.suit
  end

  def same_value?(other_card)
    value == other_card.value
  end

  

end
