require 'hand'

describe Hand do
  let(:hand) { Hand.new }
  let(:c1) { double(:card, :value => :two, :suit => :hearts) }
  let(:c2) { double(:card, :value => :three, :suit => :hearts) }
  let(:c3) { double(:card, :value => :four, :suit => :hearts) }
  let(:c4) { double(:card, :value => :five, :suit => :hearts ) }
  let(:c5) { double(:card, :value => :six, :suit => :hearts) }
  let(:c6) { double(:card, :value => :six, :suit => :spades) }

  describe "#cards" do
    it "returns an array of cards" do
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


end
