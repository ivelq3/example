FactoryBot.define do
  factory :bonus_payment_timesheet, class: 'BonusPayment::Timesheet' do
    external_id { Faker::Number.within(range: 1..999) }
    amount { Random.new.rand(1..160) }
    month { Time.zone.today.beginning_of_month }
    association :user, factory: :user
    association :charge_code, factory: :bonus_payment_charge_code
  end
end
