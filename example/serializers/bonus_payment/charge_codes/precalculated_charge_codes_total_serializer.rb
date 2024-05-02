class BonusPayment::ChargeCodes::PrecalculatedChargeCodesTotalSerializer
  include Alba::Resource

  root_key :precalculated_charge_codes_total

  attribute :time_percent_by_charge_codes do |obj|
    params[:round] ? obj.time_percent_by_charge_codes&.round : obj.time_percent_by_charge_codes
  end

  attribute :salary_by_charge_codes do |obj|
    params[:round] ? obj.salary_by_charge_codes&.round : obj.salary_by_charge_codes
  end

  attribute :bonus_amount_by_charge_codes do |obj|
    params[:round] ? obj.bonus_amount_by_charge_codes&.round : obj.bonus_amount_by_charge_codes
  end

  attribute :hours_worked_by_charge_codes do |obj|
    params[:round] ? obj.hours_worked_by_charge_codes&.round : obj.hours_worked_by_charge_codes
  end
end
