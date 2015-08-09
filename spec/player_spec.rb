require 'player'

describe Player do
  

  subject(:player1) { Player.new }
  subject(:hand) { 
    double("hand", 
    :cards => [ace, two, three, four, five], 
    :values => [:ace, :two, :three, :four, :five]
    )
  }
  subject(:hand_no_ace) { 
    double("hand", :cards => [two, two, three, four, five], 
    :values => [:two, :two, :three, :four, :five]
    )
  }
  
  let(:hand_cards)  { [1, 2, 3, 4, 5] }
  let(:ace)   { double("ace", :value => :ace) }
  let(:two)   { double("two", :value => :two) }
  let(:three) { double("three", :value => :three) }
  let(:four)  { double("four", :value => :four) }
  let(:five)  { double("five", :value => :five) }
  
  describe "#new_hand" do
      it "instantiates a new hand" do
        player1.new_hand(hand)
        expect(player1.hand).to eq(hand)
      end
  end
  
  describe "#receive" do
    it "adds cards to existing hand" do
      expect(hand).to receive(:add_cards).with([ace, two])
      player1.hand = hand
      player1.receive([ace, two])
    end
    
  end
  
  describe "#discard" do
    it "removes specified cards from hand" do
      expect(hand).to receive(:discard).with([1,2,3])
      player1.hand = hand
      player1.discard([1,2,3])
    end

      
    context "when remaining card is an Ace" do
      it "discards 4 cards" do
        expect(hand).to receive(:discard).with([1,2,3,4])
        player1.hand = hand
        player1.discard([1,2,3,4])
      end
    end
    
    context "when remaining card is not an Ace" do
      it "does not discard 4 cards" do
        player1.hand = hand_no_ace
        expect{ player1.discard([1,2,3,4]) }.to raise_error(PokerRulesError)
      end
    end
  end
    
  describe "#fold" do
    it "returns cards back to the deck" do
      player1.hand = hand
      player1.fold
      expect(player1.hand).to be_nil
    end
  end
  
  describe "#call" do
    it "reduces bankroll" 
    it "cannot call if funds are insufficient"
  end
  
  describe "#raise" do
  end


end
