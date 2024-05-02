class BonusPayment::Actions::Bonuses::UpdateCollectionContract < BonusPayment::Base
  params do
    optional(:user_ids).array(:integer)
    required(:months).array(:string)
    optional(:calculation_base_field).value(:string)
    optional(:charge_code_names).array(:string)
    optional(:allowed_charge_codes).array(:string)

    required(:bonus_detail_attributes).hash do
      optional(:quantity_salary).value(:float)
      optional(:contribution).value(:float)
      optional(:overwork).value(:float)
      optional(:kpi).value(:float)
    end
  end

  rule(:bonus_detail_attributes) do
    key.failure(:at_least_one_filled) if values[:bonus_detail_attributes].blank?
  end
end
