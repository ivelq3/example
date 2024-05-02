class BonusPayment::UserPreferences < ApplicationRecord
  belongs_to :user
  validates :period, presence: true
  validates :period, uniqueness: { scope: %i[user_id] }
end
