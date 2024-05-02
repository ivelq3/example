module BonusPayment
  module Bonuses
    PrecalculatedPeriod = Struct.new(
      :user,
      :bonus,
      :bonus_total,
      :payment_limit,
      :precalculated_charge_codes,
      :precalculated_charge_codes_total,
      keyword_init: true
    )
  end
end
