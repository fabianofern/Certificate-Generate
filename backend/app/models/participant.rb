class Participant < ApplicationRecord
  has_many :certificates, dependent: :destroy
  has_many :events, through: :certificates

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :cpf, presence: true, uniqueness: true
  validates :registration, uniqueness: true, allow_blank: true

  before_validation :cleanup_cpf

  private

  def cleanup_cpf
    self.cpf = cpf.gsub(/\D/, '') if cpf.present?
  end
end