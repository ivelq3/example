class BonusPayment::ChargeCodes::PrecalculatedChargeCodeSerializer
  include Alba::Resource

  root_key :precalculated_charge_code, :precalculated_charge_code

  one :charge_code, resource: BonusPayment::ChargeCodes::ChargeCodeSerializer
  one :precalculation, resource: BonusPayment::ChargeCodes::ChargeCodePrecalculationSerializer
end
