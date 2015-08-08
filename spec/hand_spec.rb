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
          hand = Hand.new([h4, h4, h5, h6, h10])
          hand.find_pairs(:pair)
          expect(hand.value).to eq({ :rank => 1, 
                                     :made_cards => [4], 
                                     :kicker_cards => [5, 6, 10] })
        end
        
        it "returns #value" do
          hand = Hand.new([h4, h4, h5, h6, h10])
          expect(hand.find_pairs(:pair)).to eq({ :rank => 1, 
                                     :made_cards => [4], 
                                     :kicker_cards => [5, 6, 10] })
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
          hand = Hand.new([h4, h4, h5, h5, h10])
          hand.find_pairs(:two_pair)
          expect(hand.value).to eq({
            :rank => 2, 
            :made_cards => [4, 5], 
            :kicker_cards => 10 })
        end
        
        it "returns #value" do
          hand = Hand.new([h4, h4, h5, h5, h10])
          expect(hand.find_pairs(:two_pair)).to eq({ 
            :rank => 2, 
            :made_cards => [4, 5], 
            :kicker_cards => 10 })
        end
      end
      
      context "when two pair is not found" do
        
        it "returns nil" do
          hand = Hand.new([h4, h5, h6, h10, hj])
          
          expect(hand.find_pairs(:two_pair)).to be(nil)
        end
      end
  
    end
  end
  
  describe "#find_trips" do
    
    context "when trips are found" do
      
      it "sets #value" do
        hand = Hand.new([h4, h4, h4, h5, h10])
        hand.find_trips
        expect(hand.value).to eq({ 
          :rank => 3, 
          :made_cards => [4], 
          :kicker_cards => [5, 10] 
                                  })
        end
      it "returns #value" do
        hand = Hand.new([h4, h4, h4, h5, h10])
     
        expect(hand.find_trips).to eq({ 
          :rank => 3, 
          :made_cards => [4], 
          :kicker_cards => [5, 10] })
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
        expect(hand.value).to eq({ :rank => 4, :made_cards => [2,3,4,5,6] })
      end
      
      it "returns #value" do
        hand = Hand.new([h2, h3, h4, h5, h6])
        expect(hand.find_straight).to eq({ :rank => 4, :made_cards => [2,3,4,5,6] })
      end
      
      it "can be ace-high" do
        hand = Hand.new([h2, h3, h4, h5, sa])
        expect(hand.find_straight).to eq({ :rank => 4, :made_cards => [1,2,3,4,5] })
      end
      
      it "can be ace-low" do
        hand = Hand.new([h10, hj, hq, sk, sa])
        expect(hand.find_straight).to eq({ :rank => 4, :made_cards => [10,11,12,13,14] })
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
        expect(hand.value).to eq({ :rank => 5, :made_cards => [2,3,4,5,10] })
      end
      
      it "returns #value"
    end
    
    context "when a flush is not found" do
      it "returns nil" 
    end
  end
  
  describe "#find_straight_flush" do 
    
    context "when a straight flush is found" do
      it "sets #value"
      it "returns #value"
    end
    
    context "when a straight flush is not found" do
      it "returns nil" 
    end
  end
  

end
