FactoryBot.define do
  factory :bonus_payment_role, class: 'BonusPayment::Role' do
    association :user, factory: :user
    association :department, factory: :department
    name { BonusPayment::Role::ROLES[:assistant] }

    trait :admin do
      name { BonusPayment::Role::ROLES[:admin] }
    end
  end
end
