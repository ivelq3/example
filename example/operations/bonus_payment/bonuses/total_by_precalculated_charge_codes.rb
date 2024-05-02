class BonusPayment::Bonuses::TotalByPrecalculatedChargeCodes < DryOperation
  Total = Struct.new(
    :time_percent_by_charge_codes,
    :salary_by_charge_codes,
    :bonus_amount_by_charge_codes,
    :hours_worked_by_charge_codes,
    keyword_init: true
  )

  def call(precalculated_charge_codes:, allowed_charge_codes:)
    not_use_in_calculation = BonusPayment::ChargeCode::NOT_WORKING_KINDS - allowed_charge_codes

    filtered = precalculated_charge_codes.filter do |obj|
      next if obj.charge_code.kind.in? not_use_in_calculation

      obj
    end

    salary_by_charge_codes = filtered.sum {|obj| obj.precalculation.salary_by_charge_code }
    time_percent_by_charge_codes = filtered.sum {|obj| obj.precalculation.time_percent_by_charge_code }
    bonus_amount_by_charge_codes = filtered.sum {|obj| obj.precalculation.bonus_amount_by_charge_code }
    hours_worked_by_charge_codes = filtered.sum {|obj| obj.precalculation.hours_worked_by_charge_code }

    Total.new(
      time_percent_by_charge_codes:,
      salary_by_charge_codes:,
      bonus_amount_by_charge_codes:,
      hours_worked_by_charge_codes:
    )
  end
end
