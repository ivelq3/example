class BonusPayment::BonusDetails::BonusDetailSerializer
  include Alba::Resource

  root_key :bonus_detail, :bonus_details

  attributes :id, :bonus_id, :charge_code_id, :fin_year,
             :quantity_salary, :contribution, :overwork, :kpi

  attribute :calculated_amount do |bonus_details|
    params[:round] ? bonus_details.calculated_amount&.round : bonus_details.calculated_amount
  end

  attribute :manual_amount do |bonus_details|
    params[:round] ? bonus_details.manual_amount&.round : bonus_details.manual_amount
  end

  attribute :payment_amount do |bonus_details|
    params[:round] ? bonus_details.payment_amount&.round : bonus_details.payment_amount
  end

  attribute :bonus_from_file do |bonus_details|
    params[:round] ? bonus_details.bonus_from_file&.round : bonus_details.bonus_from_file
  end

  attribute :current_salary_by_charge_code do |bonus_details|
    params[:round] ? bonus_details.current_salary_by_charge_code&.round : bonus_details.current_salary_by_charge_code
  end

  attribute :bonus_amount_by_charge_code do |bonus_details|
    params[:round] ? bonus_details.bonus_amount_by_charge_code&.round : bonus_details.bonus_amount_by_charge_code
  end

  attribute :salary_by_charge_code do |bonus_details|
    params[:round] ? bonus_details.salary_by_charge_code&.round : bonus_details.salary_by_charge_code
  end

  attribute :time_percent_by_charge_code do |bonus_details|
    params[:round] ? bonus_details.time_percent_by_charge_code&.round : bonus_details.time_percent_by_charge_code
  end

  attribute :hours_worked_by_charge_code do |bonus_details|
    params[:round] ? bonus_details.hours_worked_by_charge_code&.round : bonus_details.hours_worked_by_charge_code
  end
end
