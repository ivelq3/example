class BonusPayment::PrecalculatedPeriodSerializer
  include Alba::Resource

  attribute :user do |obj|
    BonusPayment::Users::UserSerializer.new(obj.user).to_h
  end

  attribute :charge_codes_info do |obj|
    {
      total: BonusPayment::ChargeCodes::PrecalculatedChargeCodesTotalSerializer.new(
        obj.precalculated_charge_codes_total, params: { round: true }
      ).to_h,
      precalculated_charge_codes_by_period: BonusPayment::ChargeCodes::PrecalculatedChargeCodeSerializer.new(
        obj.precalculated_charge_codes, params: { round: true }
      ).to_h
    }
  end

  attribute :bonus_info do |obj|
    {
      total: BonusPayment::Bonuses::BonusTotalSerializer.new(obj.bonus_total, params: { round: true }).to_h,
      bonus: BonusPayment::Bonuses::BonusSerializer.new(obj.bonus, params: { round: true }).to_h,
      payment_limit: BonusPayment::PaymentLimitSerializer.new(obj.payment_limit, params: { round: true }).to_h
    }
  end
end
