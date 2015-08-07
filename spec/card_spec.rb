require 'card'

describe Card do

  let(:card) { Card.new(:ace, :spades)}

  describe "#value" do
    it "returns the value of the card" do
      expect(card.value).to eq(:ace)
    end
  end

  describe "#suit" do
    it 'returns the suit of the card' do
      expect(card.suit).to eq(:spades)
    end
  end

  describe "#poker_value" do
    it "returns the poker value of the card" do
      expect(card.poker_value).to eq(14)
    end
  end

end
