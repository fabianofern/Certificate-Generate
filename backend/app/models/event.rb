class Event < ApplicationRecord
  has_many :certificates, dependent: :destroy
  has_many :participants, through: :certificates

  validates :title, presence: true
  validates :workload, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :location, presence: true
  validates :instructor_name, presence: true
  validates :instructor_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :end_date_after_start_date

  def period
    return "" unless start_date && end_date
    if start_date == end_date
      start_date.strftime("%d/%m/%Y")
    else
      "#{start_date.strftime("%d/%m/%Y")} a #{end_date.strftime("%d/%m/%Y")}"
    end
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "deve ser posterior à data de início")
    end
  end
end