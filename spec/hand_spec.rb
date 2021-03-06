require 'hand'

describe Hand do

  let(:sa)  { double(:card, :value => :ace,   :suit => :spades, :poker_value => 14) }
  let(:h2)  { double(:card, :value => :two,   :suit => :hearts, :poker_value => 2)  }
  let(:h3)  { double(:card, :value => :three, :suit => :hearts, :poker_value => 3)  }
  let(:h4)  { double(:card, :value => :four,  :suit => :hearts, :poker_value => 4)  }
  let(:h5)  { double(:card, :value => :five,  :suit => :hearts, :poker_value => 5)  }
  let(:h6)  { double(:card, :value => :six,   :suit => :hearts, :poker_value => 6)  }
  let(:s6)  { double(:card, :value => :six,   :suit => :spades, :poker_value => 6)  }
  let(:h10) { double(:card, :value => :ten,   :suit => :hearts, :poker_value => 10) }
  let(:hj)  { double(:card, :value => :jack,  :suit => :hearts, :poker_value => 11) }
  let(:hq)  { double(:card, :value => :queen, :suit => :hearts, :poker_value => 12) }
  let(:sk)  { double(:card, :value => :king,  :suit => :spades, :poker_value => 13) }
  
  subject(:straight_flush) { Hand.new([h2, h3, h4, h5, h6]) }
  subject(:flush)          { Hand.new([h2, h3, h4, h5, hq]) }
  subject(:straight)       { Hand.new([h2, h3, h4, h5, hq]) }
  subject(:quads)          { Hand.new([h5, h5, h5, h5, hj]) }
  subject(:trips)          { Hand.new([h4, h4, h4, h5, sa]) }
  subject(:two_pair)       { Hand.new([h4, h4, h5, h5, sa]) }
  subject(:pair)           {Hand.new([h4, h4, h5, h6, sa])}

  describe "::deal_from" do
    it "deals a hand of 5 cards" do
      deck_cards = [sa, h2, h3, h4, h5]
      deck = double("deck")
      
      expect(deck).to receive(:take).with(5).and_return(deck_cards) 
      hand = Hand.deal_from(deck)
      
      expect(hand.cards).to match_array(deck_cards)
    end
  end
  
  describe "#cards" do
    it "returns an array of cards" do
      hand = Hand.new
      expect(hand.cards).to eq([])
    end

    it "can be initialized with an array of cards" do
      card1 = double(:card1)
      card2 = double(:card2)
      hand = Hand.new([card1, card2])
      expect(hand.cards).to eq([card1, card2])
    end
  end


  describe '#find_pairs(rank)' do
   describe "can look for ONE pair" do  
      context "when a pair is found" do
        
        it "sets #value" do
          pair.find_pairs(:pair)
          expect(pair.value).to eq({ 
            :rank => 1, 
            :made_cards => [4], 
            :kicker_cards => [5, 6, 14] })
        end
        
        it "returns #value" do
          expect(pair.find_pairs(:pair)).to eq({ 
            :rank => 1, 
            :made_cards => [4], 
            :kicker_cards => [5, 6, 14] })
        end
      end
      
      context "when no pair is found" do
        it "returns nil" do
          hand = Hand.new([h4, h5, h6, h10, hj])
          expect(hand.find_pairs(:pair)).to be(nil)
        end
      end
    end
  
  
    describe 'can look for TWO pairs' do
     context "when two pair is found" do
        it "sets #value" do
          two_pair.find_pairs(:two_pair)
          expect(two_pair.value).to eq({
            :rank => 2, 
            :made_cards => [4, 5], 
            :kicker_cards => 14 })
        end
        
        it "returns #value" do
          expect(two_pair.find_pairs(:two_pair)).to eq({ 
            :rank => 2, 
            :made_cards => [4, 5], 
            :kicker_cards => 14 })
        end
      end
      
      context "when two pair is not found" do
        it "returns nil" do
          expect(straight.find_pairs(:two_pair)).to be(nil)
        end
      end
  
    end
  end
  
  describe "#find_trips" do
    context "when trips are found" do
      it "sets #value" do
        trips.find_trips
        expect(trips.value).to eq({ 
          :rank => 3, 
          :made_cards => [4], 
          :kicker_cards => [5, 14] })
        end
        
      it "returns #value" do
        expect(trips.find_trips).to eq({ 
          :rank => 3, 
          :made_cards => [4], 
          :kicker_cards => [5, 14] })
       end
    end
    
    context "when trips are not found" do
      it "returns nil" do
        hand = Hand.new([h4, h5, h6, h10, hj])
        expect(hand.find_trips).to be(nil)
      end
    end
  end
  
  describe "#find_quads" do 
    context "when quads are found" do
      it "sets #value" do
        hand = Hand.new([h5, h5, h5, h5, hj])
        hand.find_quads  
        expect(hand.value).to eq({ 
          :rank => 7, 
          :made_cards => [5], 
          :kicker_cards => [11] })
      end
      
      it "returns #value" do
        hand = Hand.new([h5, h5, h5, h5, hj])
        expect(hand.find_quads).to eq({ 
          :rank => 7, 
          :made_cards => [5], 
          :kicker_cards => [11] })
      end
    end
    
    context "when quads are not found" do
      it "returns nil" do
        hand = Hand.new([h4, h5, h6, h10, hj])
        expect(hand.find_quads).to be(nil) 
      end
    end
  end

  describe "#find_straight" do 
    context "when a straight is found" do
      it "sets #value" do
        hand = Hand.new([h2, h3, h4, h5, h6])
        hand.find_straight  
        expect(hand.value).to eq({ 
          :rank => 4, 
          :made_cards => [2,3,4,5,6],
          :kicker_cards => nil })
      end
      
      it "returns #value" do
        hand = Hand.new([h2, h3, h4, h5, h6])
        expect(hand.find_straight).to eq({ 
          :rank => 4, 
          :made_cards => [2,3,4,5,6],
          :kicker_cards => nil })
      end
      
      it "can be ace-high" do
        hand = Hand.new([h2, h3, h4, h5, sa])
        expect(hand.find_straight).to eq({ 
          :rank => 4, 
          :made_cards => [1,2,3,4,5],
          :kicker_cards => nil })
      end
      
      it "can be ace-low" do
        hand = Hand.new([h10, hj, hq, sk, sa])
        expect(hand.find_straight).to eq({ 
          :rank => 4, 
          :made_cards => [10,11,12,13,14],
          :kicker_cards => nil })
      end
      
    end
    
    context "when a straight is not found" do
      it "returns nil" do
        hand = Hand.new([h4, h5, h6, h10, hj])
        expect(hand.find_straight).to be(nil) 
      end
    end
  end
  
  describe "#find_flush" do 
    context "when a flush is found" do
      it "sets #value" do
        hand = Hand.new([h2, h3, h4, h5, h10])
        hand.find_flush  
        expect(hand.value).to eq({ 
          :rank => 5, 
          :made_cards => [2,3,4,5,10],
          :kicker_cards => nil })
      end
      
      it "returns #value" do
        hand = Hand.new([h2, h3, h4, h5, h10])
        expect(hand.find_flush).to eq({ 
          :rank => 5, 
          :made_cards => [2,3,4,5,10],
          :kicker_cards => nil})
      end
    end
    
    context "when a flush is not found" do
      it "returns nil" do
        hand = Hand.new([h4, h5, h6, h10, sa])
        expect(hand.find_pairs(:two_pair)).to be(nil)
      end
    end
  end
  
  describe "#find_full_house" do 
    context "when a full house is found" do
      it "sets #value" do
        hand = Hand.new([h3, h3, h3, h5, h5])
        hand.find_full_house
        expect(hand.value).to eq({ 
          :rank => 6, 
          :made_cards => [3],
          :kicker_cards => [5,5] })
      end
      
      it "returns #value" do
        hand = Hand.new([h3, h3, h3, h5, h5])
        expect(hand.find_full_house).to eq({ 
          :rank => 6, 
          :made_cards => [3],
          :kicker_cards => [5,5] })
      end
    end
    
    context "when a full house is not found" do
      it "returns nil" do
          hand = Hand.new([h4, h5, h6, h10, sa])
          expect(hand.find_full_house).to be(nil)
      end
    end
  end
  
  describe "#find_straight_flush" do 
    context "when a straight flush is found" do
      it "sets #value"  do
        hand = Hand.new([h2, h3, h4, h5, h6])
        hand.find_straight_flush  
        expect(hand.value).to eq({ 
          :rank => 8, 
          :made_cards => [2,3,4,5,6],
          :kicker_cards => nil })
      end
      
      it "returns #value"  do
        hand = Hand.new([h2, h3, h4, h5, h6])
        expect(hand.find_straight_flush ).to eq({ 
          :rank => 8, 
          :made_cards => [2,3,4,5,6],
          :kicker_cards => nil })
      end
    end
    
    context "when a straight flush is not found" do
      it "returns nil" do
        hand = Hand.new([h2, h3, h4, h5, h10])
        expect(hand.find_straight_flush ).to be(nil) 
      end
    end
  end
  
  describe "#evaluate_hand" do
    it "identifies poker hand and sets #value" do
      flush.evaluate_hand
      expect(flush.value).to eq({ 
        :rank => 5, 
        :made_cards => [2,3,4,5,12],
        :kicker_cards => nil })
    end    
  end
  
  describe "#beats?(other_hand)" do
    context "flush vs. two pair" do
      it "returns true" do
        two_pair = Hand.new([h4, h4, h4, h5, sa])
        expect(flush.beats?(two_pair)).to be_truthy
      end
    end
      
    describe "pair vs. pair" do
      context "evaluates pairs first" do
        it "pair of 4's beats pair of 2's" do
          twos = Hand.new([h2, h2, h5, h6, sa])
          expect(pair.beats?(twos)).to be_truthy
        end
      end
      
      
      context "evaluates kickers if pairs are the same" do
        it "pair of 2's with Ace kicker beats pair of 2's with King kicker" do
          twos_ace = Hand.new([h2, h2, h5, h6, sa])
          twos_king = Hand.new([h2, h2, h5, h6, sk])
          expect(twos_ace.beats?(twos_king)).to be_truthy
        end
      end
    end
  end
end
