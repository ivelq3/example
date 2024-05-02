class BonusPayment::Bonuses::PrecalculateChargeCodesByMonth < DryOperation
  def call(user:, month:)
    salary_per_period = yield fetch_salary(user:, month:)
    timesheets = yield fetch_timesheets(user:, month:)
    charge_codes = yield fetch_charge_codes(timesheets:)
    hours_worked_per_period = timesheets.sum(&:amount)

    charge_codes_with_precalculation = charge_codes.map do |charge_code|
      charge_code_timesheets = timesheets.where(charge_code:)
      hours_worked_by_charge_code = charge_code_timesheets.sum(&:amount)

      time_percent_by_charge_code = ((hours_worked_by_charge_code.to_f * 100) / hours_worked_per_period)
      salary_by_charge_code = ((salary_per_period.to_f * time_percent_by_charge_code) / 100)

      precalculation = BonusPayment::Bonuses::ChargeCodePrecalculation.new(
        time_percent_by_charge_code:,
        salary_by_charge_code:,
        hours_worked_by_charge_code:
      )

      BonusPayment::Bonuses::PrecalculatedChargeCode.new(charge_code:, precalculation:)
    end

    Success(charge_codes_with_precalculation)
  end

  private

  def fetch_salary(user:, month:)
    salary = BonusPayment::Salary.find_by(user:, month:)&.salary
    return Failure(:salary_not_found) if salary.nil?

    Success(salary)
  end

  def fetch_timesheets(user:, month:)
    timesheets = user.timesheets.where(month:)
    return Failure(:timesheets_not_found) if timesheets.blank?

    Success(timesheets)
  end

  def fetch_charge_codes(timesheets:)
    charge_codes = BonusPayment::ChargeCode.where(id: timesheets.pluck(:charge_code_id))
    return Failure(:charge_codes_not_found) if charge_codes.blank?

    Success(charge_codes)
  end
end
