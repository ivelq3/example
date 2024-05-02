FactoryBot.define do
  factory :bonus_payment_salary, class: 'BonusPayment::Salary' do
    association :user, factory: :user
    salary { Random.new.rand(30_000..100_000) }
    month { Time.zone.today.beginning_of_month }
    tab_number { '0000000001' }
  end
end
