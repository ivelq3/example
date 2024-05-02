class User < ApplicationRecord
  has_many :bonus_payment_user_preferences, class_name: 'BonusPayment::UserPreferences', dependent: :destroy
  has_many :bonus_payment_roles, class_name: 'BonusPayment::Role', dependent: :destroy
  has_many :bonus_payment_bonuses, class_name: 'BonusPayment::Bonus', dependent: :destroy
  has_many :bonus_payment_salaries, class_name: 'BonusPayment::Salary', dependent: :destroy
  has_many :timesheets, class_name: 'BonusPayment::Timesheet', dependent: :destroy
  belongs_to :scheme, class_name: 'BonusPayment::Scheme', optional: true

  scope :with_salary_in_months, lambda { |months|
    joins(:bonus_payment_salaries).where(bonus_payment_salaries: { month: months })
                                  .group(:id)
                                  .having('count(distinct bonus_payment_salaries.month) = ?', months.count)
  }

  scope :with_work_charge_codes, lambda {
    joins(timesheets: :charge_code).where.not(charge_code: { kind: BonusPayment::ChargeCode::NOT_WORKING_KINDS })
  }
end
