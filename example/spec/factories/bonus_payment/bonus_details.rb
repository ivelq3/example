FactoryBot.define do
  factory :bonus_payment_bonus_detail, class: 'BonusPayment::BonusDetail' do
    association :bonus, factory: :bonus_payment_bonus
    association :charge_code, factory: :bonus_payment_charge_code
    quantity_salary { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    contribution { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    overwork { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    kpi { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    calculated_amount { Faker::Number.decimal.round(0) }
    manual_amount { Faker::Number.decimal.round(0) }
    payment_amount { Faker::Number.decimal.round(0) }
    fin_year { Date.new(Time.zone.today.year, 4, 1) }
    current_salary_by_charge_code { 100 }
    bonus_amount_by_charge_code { 200 }
    salary_by_charge_code { 300 }
    time_percent_by_charge_code { 50 }
    hours_worked_by_charge_code { 30 }
  end
end
