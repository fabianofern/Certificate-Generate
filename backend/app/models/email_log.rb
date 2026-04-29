class EmailLog < ApplicationRecord
  belongs_to :certificate

  validates :recipient, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending sent failed] }

  enum :status, { pending: 'pending', sent: 'sent', failed: 'failed' }
end