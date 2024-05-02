class BonusPayment::Bonuses::BuildBonusByPrecalculatedChargeCodes < DryOperation
  def initialize(
    fin_year_helper: BonusPayment::FinYearHelper.new,
    recalculate: BonusPayment::BonusDetails::Recalculate.new
  )
    @fin_year_helper = fin_year_helper
    @recalculate = recalculate
  end

  attr_reader :fin_year_helper, :recalculate

  def call(user:, months:, calculation_base_field:, allowed_charge_codes:, precalculated_charge_codes:)
    bonus = BonusPayment::Bonus.new(user:, start_at: months.min, end_at: months.max, allowed_charge_codes:)
    bonus.details << precalculated_charge_codes.map do |precalculated_charge_code|
      bonus_detail = BonusPayment::BonusDetail.new(
        charge_code_id: precalculated_charge_code.charge_code.id,
        calculation_base_field:,
        fin_year: fin_year_helper.fin_year_start_from_date(Time.zone.today),
        **precalculated_charge_code.precalculation.to_h
      )
      recalculate.call(bonus_detail:)
    end

    Success(bonus)
  end
end
