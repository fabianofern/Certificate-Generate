require 'rails_helper'

RSpec.describe Certificate, type: :model do
  let(:event) { Event.create!(title: 'Test Event', workload: 10, instructor_name: 'Inst', instructor_email: 'inst@example.com', period: '2024', location: 'Remote') }
  let(:participant) { Participant.create!(name: 'Test Part', email: 'test@example.com', cpf: '09876543210') }

  describe 'callbacks' do
    it 'generates a uuid on creation' do
      certificate = Certificate.create!(event: event, participant: participant)
      expect(certificate.uuid).to be_present
    end

    it 'generates a download_token on creation' do
      certificate = Certificate.create!(event: event, participant: participant)
      expect(certificate.download_token).to be_present
      expect(certificate.download_token.length).to eq 32 # SecureRandom.hex(16)
    end
  end

  describe '#download_token_valid?' do
    it 'is valid within 7 days' do
      certificate = Certificate.create!(event: event, participant: participant)
      expect(certificate.download_token_valid?).to be true
    end

    it 'is invalid after 7 days' do
      certificate = Certificate.create!(event: event, participant: participant)
      certificate.update_columns(created_at: 8.days.ago)
      expect(certificate.download_token_valid?).to be false
    end
  end
end
