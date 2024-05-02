class BonusPayment::ChargeCodes::ChargeCodeSerializer
  include Alba::Resource

  root_key :charge_code, :charge_codes

  attributes :id, :name, :kind
end
