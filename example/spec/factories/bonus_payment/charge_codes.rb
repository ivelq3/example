FactoryBot.define do
  factory :bonus_payment_charge_code, class: 'BonusPayment::ChargeCode' do
    external_uid { Faker::Internet.uuid }
    name { Faker::Company.name }
    kind { Faker::Company.name }
    description { Faker::Company.name }
    start_at { Time.zone.today }
    end_at { Time.zone.today + 1.month }
  end
end
