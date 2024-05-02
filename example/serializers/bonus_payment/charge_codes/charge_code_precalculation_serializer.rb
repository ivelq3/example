class BonusPayment::ChargeCodes::ChargeCodePrecalculationSerializer
  include Alba::Resource

  root_key :charge_code_precalculation

  attribute :time_percent_by_charge_code do |obj|
    params[:round] ? obj.time_percent_by_charge_code&.round : obj.time_percent_by_charge_code
  end

  attribute :salary_by_charge_code do |obj|
    params[:round] ? obj.salary_by_charge_code&.round : obj.salary_by_charge_code
  end

  attribute :bonus_amount_by_charge_code do |obj|
    params[:round] ? obj.bonus_amount_by_charge_code&.round : obj.bonus_amount_by_charge_code
  end

  attribute :current_salary_by_charge_code do |obj|
    params[:round] ? obj.current_salary_by_charge_code&.round : obj.current_salary_by_charge_code
  end

  attribute :hours_worked_by_charge_code do |obj|
    params[:round] ? obj.hours_worked_by_charge_code&.round : obj.hours_worked_by_charge_code
  end

  def select(key, _value)
    return true unless params[:precalculation_fields]

    params[:precalculation_fields].include?(key.to_sym)
  end
end
