require 'hand'

describe Hand do
  let(:c1) { double(:card, :value => :two, :suit => :hearts, :poker_value => 2) }
  let(:c2) { double(:card, :value => :three, :suit => :hearts, :poker_value => 3) }
  let(:c3) { double(:card, :value => :four, :suit => :hearts, :poker_value => 4) }
  let(:c4) { double(:card, :value => :five, :suit => :hearts, :poker_value => 5 ) }
  let(:c5) { double(:card, :value => :six, :suit => :hearts, :poker_value => 6) }
  let(:c6) { double(:card, :value => :six, :suit => :spades, :poker_value => 6) }
  let(:c7) { double(:card, :value => :ace, :suit => :spades, :poker_value => 14) }
  let(:c8) { double(:card, :value => :ten, :suit => :hearts, :poker_value => 10) }
  let(:c9) { double(:card, :value => :jack, :suit => :hearts, :poker_value => 11 ) }
  let(:c10) { double(:card, :value => :queen, :suit => :hearts, :poker_value => 12) }
  let(:c11) { double(:card, :value => :king, :suit => :spades, :poker_value => 13) }

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

  describe '#num_pairs' do

    it 'returns 0 if there are no pairs' do
      hand = Hand.new([c1, c2, c3, c4, c5])
      expect(hand.num_pairs).to eq(0)
    end

    it 'returns 1 if there is one pair' do
      hand = Hand.new([c1, c1, c3, c4, c5])
      expect(hand.num_pairs).to eq(1)
    end

    it 'returns 2 if there are two pairs' do
      hand = Hand.new([c1, c1, c3, c3, c5])
      expect(hand.num_pairs).to eq(2)
    end

    it 'does not count 3 of a kind as a pair' do
      hand = Hand.new([c1, c1, c1, c3, c5])
      expect(hand.num_pairs).to eq(0)
    end

    it 'does not count 4 of a kind as a pair' do
      hand = Hand.new([c1, c1, c1, c1, c5])
      expect(hand.num_pairs).to eq(0)
    end
  end

  describe '#has_trips?' do
    it 'returns false if there are no triples' do
      hand = Hand.new([c1, c1, c3, c3, c5])
      expect(hand.has_trips?).to be false
    end

    it 'returns true if there is a triple' do
      hand = Hand.new([c1, c1, c1, c3, c5])
      expect(hand.has_trips?).to be true
    end

    it 'does not count 4 of a kind as a triple' do
      hand = Hand.new([c1, c1, c1, c1, c5])
      expect(hand.has_trips?).to be false
    end
  end

  describe "#has_quads?" do
    it "returns true if there are 4 of a kind" do
      hand = Hand.new([c1, c1, c1, c1, c5])
      expect(hand.has_quads?).to be true
    end

    it "returns false if there is not 4 of a kind" do
      hand = Hand.new([c1, c2, c1, c1, c5])
      expect(hand.has_quads?).to be false
    end
  end

  describe "#flush?" do
    it "returns true if hand is all the same suit" do
      hand = Hand.new([c1, c2, c3, c4, c5])
      expect(hand.flush?).to be true
    end

    it "returns false if hand is not all the same suit" do
      hand = Hand.new([c1, c2, c3, c4, c6])
      expect(hand.flush?).to be false
    end
  end

  describe "#full_house?" do
    it "returns true if hand is a full house" do
      hand = Hand.new([c1, c1, c1, c4, c4])
      expect(hand.full_house?).to be true
    end

    it "returns false for any other hand" do
      hand = Hand.new([c1, c1, c2, c4, c4])
      expect(hand.full_house?).to be false
    end
  end

  describe '#straight?' do
    it 'returns true if the hand is a straight' do
      hand = Hand.new([c1, c2, c3, c4, c5])
      expect(hand.straight?).to be true
    end

    it 'returns false if the hand is not a straight' do
      hand = Hand.new([c1, c2, c3, c4, c4])
      expect(hand.straight?).to be false
    end

    it 'returns true if the hand is a straight with ace low' do
      hand = Hand.new([c1, c2, c3, c4, c7])
      expect(hand.straight?).to be true
    end

    it 'returns true if the hand is a straight with ace high' do
      hand = Hand.new([c7, c8, c9, c10, c11])
      expect(hand.straight?).to be true
    end

    it 'returns false if straight goes around the bend' do
      hand = Hand.new([c7, c2, c9, c10, c11])
      expect(hand.straight?).to be false
    end
  end

  describe '#straight_flush?' do
    it 'returns true if straight and flush' do
      hand = Hand.new([c1, c2, c3, c4, c5])
      expect(hand.straight_flush?).to be true
    end

    it 'returns false if not straight or flush' do
      hand = Hand.new([c1, c2, c3, c4, c8])
      expect(hand.straight_flush?).to be false
    end
  end

  describe '#beats?(other_hand)' do
    it "returns true if hand beats other hand" do
      straight = Hand.new([c1, c2, c3, c4, c5])
      pair = Hand.new([c11, c2, c2, c4, c5])
      expect(straight.beats?(pair)).to be true
    end

    it "returns false if hand does not beats other hand" do
      straight = Hand.new([c1, c2, c3, c4, c5])
      pair = Hand.new([c11, c2, c2, c4, c5])
      expect(pair.beats?(straight)).to be false
    end

  end


end
