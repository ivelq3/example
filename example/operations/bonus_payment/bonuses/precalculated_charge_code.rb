module BonusPayment
  module Bonuses
    PrecalculatedChargeCode = Struct.new(:charge_code, :precalculation, keyword_init: true)
  end
end
