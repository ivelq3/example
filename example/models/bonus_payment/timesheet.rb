class BonusPayment::Timesheet < ApplicationRecord
  belongs_to :user
  belongs_to :charge_code, optional: true
end
