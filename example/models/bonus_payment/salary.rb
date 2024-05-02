class BonusPayment::Salary < ApplicationRecord
  belongs_to :user
  has_encrypted :salary, type: :integer

  validates :month, :salary, presence: true
  validates :salary, numericality: true, comparison: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :month }
end
