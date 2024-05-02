FactoryBot.define do
  factory :bonus_payment_user_preferences, class: 'BonusPayment::UserPreferences' do
    user
    period { [Date.current.beginning_of_month] }
    preferences {
      {
        calculation_base_field: BonusPayment::BonusDetail.calculation_base_fields[:bonus_amount_by_charge_code],
        allowed_charge_codes: []
      }
    }
  end
end
