FactoryBot.define do
  factory :bonus_payment_scheme, class: 'BonusPayment::Scheme' do
    code { Faker::Company.name }
    name { Faker::Company.name }
    limit { Faker::Number.decimal(l_digits: 2) }
  end
end
