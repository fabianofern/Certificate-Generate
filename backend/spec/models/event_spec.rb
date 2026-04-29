require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      event = Event.new(
        title: 'Ruby Conference',
        workload: 16,
        period: '2024-05-01 to 2024-05-02',
        location: 'São Paulo',
        instructor_name: 'DHH',
        instructor_email: 'dhh@example.com'
      )
      expect(event).to be_valid
    end

    it 'is invalid without a title' do
      event = Event.new(title: nil)
      expect(event).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many participants' do
      association = described_class.reflect_on_association(:participants)
      expect(association.macro).to eq :has_many
    end

    it 'has many certificates' do
      association = described_class.reflect_on_association(:certificates)
      expect(association.macro).to eq :has_many
    end
  end
end
