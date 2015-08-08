require 'deck'
describe Deck do
  subject(:deck) {Deck.new}
  
  describe '#initialize' do
    it 'has 52 cards' do
      expect(deck.count).to eq(52)
    end

    it 'has all different cards' do
      all_cards = deck.cards
      .map { |card| [card.value, card.suit] }
      .uniq
      .count
      
      expect(all_cards).to eq (52)
    end
  end

  describe "#take(n)" do
    it "takes 'n' cards from top of deck" do
      deck.take(5)
      expect(deck.count).to eq(52 - 5)
    end

    it "returns the top 'n' cards from the deck" do
      top_five = deck.cards.last(5)
      expect(deck.take(5)).to eq(top_five)
    end
  end

  describe "#shuffle" do
    it "shuffles the deck" do
      before_shuffle = deck.cards.dup
      expect(deck.shuffle).not_to eq(before_shuffle)
    end
  end

end
