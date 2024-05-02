class BonusPayment::Role < ApplicationRecord
  ROLES = { admin: 'bonus_admin', assistant: 'bonus_assistant' }.freeze

  belongs_to :user
  belongs_to :department

  validates :name, presence: true, inclusion: { in: ROLES.values }
end
