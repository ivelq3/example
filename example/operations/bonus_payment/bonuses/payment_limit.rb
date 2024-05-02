class BonusPayment::Bonuses::PaymentLimit < DryOperation
  PaymentLimit = Struct.new(:limit, :exit_from_limit, keyword_init: true)

  def initialize(fin_year_helper: BonusPayment::FinYearHelper.new)
    @fin_year_helper = fin_year_helper
  end

  attr_reader :fin_year_helper

  def call(user:, bonus:)
    return PaymentLimit.new(limit: nil, exit_from_limit: nil) if user.scheme&.limit.nil?

    current_fin_year = fin_year_helper.fin_year_start_from_date(Date.current)
    payment_limit = fetch_payment_limit(user:, fin_year: current_fin_year)
    bonus_payment_amount = fetch_bonus_payment_amount(bonus:, fin_year: current_fin_year)
    paid_bonuses_payment_amount = fetch_paid_bonuses_payment_amount(user:, fin_year: current_fin_year)
    exit_from_limit = payment_limit - (bonus_payment_amount + paid_bonuses_payment_amount)

    PaymentLimit.new(limit: payment_limit, exit_from_limit:)
  end

  private

  def fetch_payment_limit(user:, fin_year:)
    months_worked = (fin_year..Date.current).map(&:beginning_of_month).uniq
    salary_per_fin_year = BonusPayment::Salary.where(user:, month: months_worked).filter_map(&:salary).sum
    (salary_per_fin_year * user.scheme.limit) / 100
  end

  def fetch_bonus_payment_amount(bonus:, fin_year:)
    details = bonus.details.filter {|detail| detail.fin_year == fin_year }
    details.filter_map(&:payment_amount).sum
  end

  def fetch_paid_bonuses_payment_amount(user:, fin_year:)
    BonusPayment::BonusDetail.joins(:bonus)
                             .where(fin_year:, bonus: { state: BonusPayment::Bonus::STATE_PAID, user: })
                             .filter_map(&:payment_amount)
                             .sum
  end
end
