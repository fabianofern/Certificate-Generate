class Certificate < ApplicationRecord
  belongs_to :event
  belongs_to :participant
  has_many :email_logs, dependent: :destroy

  validates :uuid, presence: true, uniqueness: true
  validates :event, :participant, presence: true

  before_validation :generate_uuid, on: :create
  before_create :generate_download_token
  before_save :generate_qr_code_data

  scope :sent, -> { where.not(sent_at: nil) }
  scope :pending, -> { where(sent_at: nil) }

  def sent?
    sent_at.present?
  end

  def download_token_valid?
    created_at > 7.days.ago
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def generate_download_token
    self.download_token = SecureRandom.hex(16)
  end

  def generate_qr_code_data
    # Forçamos a geração sempre que o QR code estiver vazio ou os dados mudarem
    self.qr_code_data = build_qr_code_data if qr_code_data.blank?
  end

  def build_qr_code_data
    # Busca segura dos objetos caso a associação ainda não tenha sido carregada no cache
    p = participant || Participant.find_by(id: participant_id)
    e = event || Event.find_by(id: event_id)
    
    return nil unless p && e

    json_data = {
      uuid: uuid,
      participant_name: p.name,
      participant_email: p.email,
      event_title: e.title,
      workload: e.workload,
      period: e.period,
      location: e.location,
      instructor_name: e.instructor_name,
      issue_date: created_at&.strftime('%d/%m/%Y') || Time.current.strftime('%d/%m/%Y')
    }.to_json

    host = ENV.fetch('APP_HOST', 'http://localhost:3000')
    "#{host}/validate?data=#{CGI.escape(json_data)}"
  end
end
