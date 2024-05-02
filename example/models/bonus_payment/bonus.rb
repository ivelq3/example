class BonusPayment::Bonus < ApplicationRecord
  include AASM

  belongs_to :user, optional: true
  belongs_to :scheme, class_name: 'BonusPayment::Scheme', optional: true
  has_many :details, class_name: 'BonusPayment::BonusDetail', inverse_of: :bonus, dependent: :destroy

  validates :user_id, uniqueness: { scope: %i[start_at end_at state] }, if: -> { draft? }

  aasm column: :state do
    state :draft, initial: true
    state :paid

    event :to_paid do
      transitions from: :draft, to: :paid
    end
  end
end
