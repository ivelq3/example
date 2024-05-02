class BonusPayment::Scheme < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :code, :name, presence: true
end
