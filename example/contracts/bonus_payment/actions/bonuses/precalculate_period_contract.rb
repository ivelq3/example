class BonusPayment::Actions::Bonuses::PrecalculatePeriodContract < BonusPayment::Base
  params do
    required(:months).array(:string)
    optional(:calculation_base_field).value(:string)
    optional(:allow_use_charge_code_in_calculation).array(:string)
    optional(:page).value(:integer)
    optional(:per_page).value(:integer)
    optional(:q).hash
  end
end
