class BonusPayment::BonusDetails::Recalculate < DryOperation
  DEFAULT_BASE = 'bonus_amount_by_charge_code'.freeze

  def call(bonus_detail:)
    base = case bonus_detail.calculation_base_field
           when 'current_salary_by_charge_code' then bonus_detail.current_salary_by_charge_code
           when 'bonus_amount_by_charge_code' then bonus_detail.bonus_amount_by_charge_code
           when 'salary_by_charge_code' then bonus_detail.salary_by_charge_code
           end

    bonus_detail.calculated_amount =
      if coefficients_zero?(bonus_detail)
        base
      else
        base * (bonus_detail.quantity_salary + bonus_detail.contribution + bonus_detail.overwork + bonus_detail.kpi)
      end

    bonus_detail.payment_amount = payment_amount_by_priority(bonus_detail:)
    bonus_detail
  end

  private

  def coefficients_zero?(bonus_detail)
    [bonus_detail.quantity_salary, bonus_detail.contribution, bonus_detail.overwork, bonus_detail.kpi].all?(&:zero?)
  end

  def payment_amount_by_priority(bonus_detail:)
    bonus_detail.bonus_from_file || bonus_detail.manual_amount || bonus_detail.calculated_amount
  end
end
