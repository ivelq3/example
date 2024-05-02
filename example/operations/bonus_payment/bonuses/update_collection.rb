class BonusPayment::Bonuses::UpdateCollection < DryOperation
  def initialize(
    precalculate_charge_codes_by_period: BonusPayment::Bonuses::PrecalculateChargeCodesByPeriod.new,
    build_bonus_by_precalculated_charge_codes: BonusPayment::Bonuses::BuildBonusByPrecalculatedChargeCodes.new,
    recalculate: BonusPayment::BonusDetails::Recalculate.new
  )
    @precalculate_charge_codes_by_period = precalculate_charge_codes_by_period
    @build_bonus_by_precalculated_charge_codes = build_bonus_by_precalculated_charge_codes
    @recalculate = recalculate
  end

  attr_reader :precalculate_charge_codes_by_period, :build_bonus_by_precalculated_charge_codes,
              :recalculate

  def call(
    user:,
    months:,
    calculation_base_field:,
    allowed_charge_codes:,
    bonus_detail_attributes:,
    update_details_with_charge_code_names:
  )
    bonus = find_bonus(user:, months:)
    if bonus.nil?
      bonus = yield create_bonus_by_precalculation(user:, months:, calculation_base_field:, allowed_charge_codes:)
    end

    skip_details_with_charge_code_kinds = BonusPayment::ChargeCode::NOT_WORKING_KINDS - allowed_charge_codes

    details = bonus.details.joins(:charge_code).where.not(charge_code: { kind: skip_details_with_charge_code_kinds })

    if update_details_with_charge_code_names.present?
      details = details.where(charge_code: { name: update_details_with_charge_code_names} )
    end

    details.find_each do |bonus_detail|
      bonus_detail.assign_attributes(bonus_detail_attributes)
      bonus_detail = recalculate.call(bonus_detail:)
      bonus_detail.save
    end

    Success(bonus)
  end

  private

  def find_bonus(user:, months:)
    BonusPayment::Bonus.find_by(user:, start_at: months.min, end_at: months.max)
  end

  def create_bonus_by_precalculation(user:, months:, calculation_base_field:, allowed_charge_codes:)
    precalculated_charge_codes = yield precalculate_charge_codes_by_period.call(user:, months:)
    bonus = yield build_bonus_by_precalculated_charge_codes.call(
      user:, months:, calculation_base_field:, precalculated_charge_codes:, allowed_charge_codes:
    )
    bonus.save ? Success(bonus) : Failure(bonus)
  end
end
