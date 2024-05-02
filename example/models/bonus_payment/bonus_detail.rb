class BonusPayment::BonusDetail < ApplicationRecord
  enum calculation_base_field: {
    bonus_amount_by_charge_code: 'bonus_amount_by_charge_code',
    current_salary_by_charge_code: 'current_salary_by_charge_code',
    salary_by_charge_code: 'salary_by_charge_code'
  }

  belongs_to :bonus, class_name: 'BonusPayment::Bonus', inverse_of: :details
  belongs_to :charge_code,
             class_name: 'BonusPayment::ChargeCode',
             inverse_of: :details,
             optional: true

  validates :kpi, :overwork, :contribution, :quantity_salary, presence: true
  validates :kpi, :overwork, :contribution, :quantity_salary, numericality: { greater_than_or_equal_to: 0 }
end
