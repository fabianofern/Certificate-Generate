require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      participant = Participant.new(name: 'John Doe', email: 'john@example.com', cpf: '12345678901')
      expect(participant).to be_valid
    end

    it 'is invalid without a name' do
      participant = Participant.new(name: nil)
      expect(participant).to_not be_valid
    end

    it 'is invalid without an email' do
      participant = Participant.new(email: nil)
      expect(participant).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many certificates' do
      association = described_class.reflect_on_association(:certificates)
      expect(association.macro).to eq :has_many
    end
  end
end
