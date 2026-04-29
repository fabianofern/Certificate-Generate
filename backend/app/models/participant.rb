class Participant < ApplicationRecord
  has_many :certificates, dependent: :destroy
  has_many :events, through: :certificates

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :cpf, presence: true, uniqueness: true
end