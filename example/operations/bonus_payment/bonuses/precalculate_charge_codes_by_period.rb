class BonusPayment::Bonuses::PrecalculateChargeCodesByPeriod < DryOperation
  def initialize(precalculate_charge_codes_by_month: BonusPayment::Bonuses::PrecalculateChargeCodesByMonth.new)
    @precalculate_charge_codes_by_month = precalculate_charge_codes_by_month
  end

  attr_reader :precalculate_charge_codes_by_month

  def call(user:, months:)
    current_salary = BonusPayment::Salary.where(user:).order(month: :desc).first&.salary

    precalculated_charge_codes_by_period = months.map do |month|
      yield precalculate_charge_codes_by_month.call(user:, month:)
    end

    precalculated_charge_codes_by_period = group_precalculations_by_charge_code(
      precalculated_charge_codes_by_period:
    )
    precalculated_charge_codes_by_period = sum_precalculations(
      precalculated_charge_codes_by_period:
    )
    precalculated_charge_codes_by_period = add_bonus_amount(
      precalculated_charge_codes_by_period:, months_count: months.count
    )
    precalculated_charge_codes_by_period = recalculate_time_percent_to_average(
      precalculated_charge_codes_by_period:, months_count: months.count
    )
    precalculated_charge_codes_by_period = add_current_salary_by_charge_code(
      precalculated_charge_codes_by_period:, current_salary:
    )

    Success(precalculated_charge_codes_by_period)
  end

  private

  def group_precalculations_by_charge_code(precalculated_charge_codes_by_period:)
    precalculated_charge_codes_by_period.flatten.each_with_object({}) do |item, group|
      group[item.charge_code] ||= []
      group[item.charge_code] << item.precalculation
    end
  end

  def sum_precalculations(precalculated_charge_codes_by_period:)
    precalculated_charge_codes_by_period.transform_values! do |precalculations|
      time_percent_by_charge_code = precalculations.sum(&:time_percent_by_charge_code)
      salary_by_charge_code = precalculations.sum(&:salary_by_charge_code)
      hours_worked_by_charge_code = precalculations.sum(&:hours_worked_by_charge_code)

      BonusPayment::Bonuses::ChargeCodePrecalculation.new(
        time_percent_by_charge_code:,
        salary_by_charge_code:,
        hours_worked_by_charge_code:
      )
    end

    precalculated_charge_codes_by_period.map do |charge_code, precalculation|
      BonusPayment::Bonuses::PrecalculatedChargeCode.new(charge_code:, precalculation:)
    end
  end

  def add_bonus_amount(precalculated_charge_codes_by_period:, months_count:)
    precalculated_charge_codes_by_period.each do |precalculated_charge_code|
      bonus_amount_by_charge_code = precalculated_charge_code.precalculation.salary_by_charge_code / months_count

      precalculated_charge_code.precalculation.bonus_amount_by_charge_code = bonus_amount_by_charge_code
    end
  end

  def recalculate_time_percent_to_average(precalculated_charge_codes_by_period:, months_count:)
    precalculated_charge_codes_by_period.each do |precalculated_charge_code|
      time_percent_by_charge_code = precalculated_charge_code.precalculation.time_percent_by_charge_code / months_count

      precalculated_charge_code.precalculation.time_percent_by_charge_code = time_percent_by_charge_code
    end
  end

  def add_current_salary_by_charge_code(precalculated_charge_codes_by_period:, current_salary:)
    precalculated_charge_codes_by_period.each do |precalculated_charge_code|
      current_salary_by_charge_code =
        (current_salary * precalculated_charge_code.precalculation.time_percent_by_charge_code) / 100

      precalculated_charge_code.precalculation.current_salary_by_charge_code = current_salary_by_charge_code
    end
  end
end
