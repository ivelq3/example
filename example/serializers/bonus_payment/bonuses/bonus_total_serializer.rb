class BonusPayment::Bonuses::BonusTotalSerializer
  include Alba::Resource

  root_key :bonus_total

  attribute :calculated_amount do |bonus_total|
    params[:round] ? bonus_total.calculated_amount&.round : bonus_total.calculated_amount
  end

  attribute :manual_amount do |bonus_total|
    params[:round] ? bonus_total.manual_amount&.round : bonus_total.manual_amount
  end

  attribute :bonus_from_file do |bonus_total|
    params[:round] ? bonus_total.bonus_from_file&.round : bonus_total.bonus_from_file
  end

  attribute :payment_amount do |bonus_total|
    params[:round] ? bonus_total.payment_amount&.round : bonus_total.payment_amount
  end
end
