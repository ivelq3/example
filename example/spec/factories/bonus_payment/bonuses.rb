FactoryBot.define do
  factory :bonus_payment_bonus, class: 'BonusPayment::Bonus' do
    association :user
    association :scheme, factory: :bonus_payment_scheme
    amount { Random.new.rand(100..2_000_000) }
    start_at { Time.zone.today }
    end_at { Time.zone.today + 1.month }
    allowed_charge_codes { [] }
  end
end
