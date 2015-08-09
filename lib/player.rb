class Player
  
  attr_accessor :hand, :bankroll
  
  def initialize(bankroll)
    @bankroll = bankroll
  end
  
  def new_hand(hand)
    @hand = hand
    
  end
  
  def receive(cards)
    hand.add_cards(cards)
  end
  
  def discard(indices)
    if indices.count == 4
      if !hand.values.include?(:ace)
        raise PokerRulesError.new("You don't have an Ace!") 
      elsif hand.values.include?(:ace) && hand.values[10 - indices.reduce(:+)] != :ace
        raise PokerRulesError.new("You don't have an Ace!") 
      end
    end
    
    hand.discard(indices)
  end
  
  def fold
    self.hand = nil
  end
end

class PokerRulesError < StandardError
end