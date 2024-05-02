module BonusPayment
  module Bonuses
    ChargeCodePrecalculation = Struct.new(
      :time_percent_by_charge_code,
      :salary_by_charge_code,
      :bonus_amount_by_charge_code,
      :current_salary_by_charge_code,
      :hours_worked_by_charge_code,
      keyword_init: true
    )
  end
end
