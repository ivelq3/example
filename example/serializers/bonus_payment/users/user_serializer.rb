class BonusPayment::Users::UserSerializer
  include Alba::Resource

  root_key :user, :users

  attributes :id, :full_name

  one :scheme, resource: BonusPayment::Schemes::SchemeSerializer

  attribute :current_salary do |user|
    BonusPayment::Salary.where(user:).order(month: :desc).first&.salary
  end

  attribute :block do |user|
    {
      id: user.department&.parent&.id,
      name: user.department&.parent&.name
    }
  end

  attribute :department do |user|
    {
      id: user.department&.id,
      name: user.department&.name
    }
  end

  attribute :position do |user|
    user.employment&.position
  end

  attribute :currency do |user|
    user.employment&.currency
  end

  attribute :probation_end do |user|
    user.employment&.probation_end
  end

  attribute :main_workplace do |user|
    user.employment&.main_workplace
  end

  attribute :seniority do |user|
    user.employment&.seniority
  end

  attribute :rate do |user|
    user.employment&.rate
  end
end
