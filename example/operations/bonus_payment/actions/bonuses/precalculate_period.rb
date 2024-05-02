class BonusPayment::Actions::Bonuses::PrecalculatePeriod < DryOperation
  PER_PAGE = 10

  def initialize(
    contract: BonusPayment::Actions::Bonuses::PrecalculatePeriodContract,
    precalculate_charge_codes_by_period: BonusPayment::Bonuses::PrecalculateChargeCodesByPeriod.new,
    total_by_precalculated_charge_codes: BonusPayment::Bonuses::TotalByPrecalculatedChargeCodes.new,
    total_by_bonus_details: BonusPayment::Bonuses::TotalByBonusDetails.new,
    fetch_managed_users: BonusPayment::Users::FetchManagedUsers.new,
    build_bonus_by_precalculated_charge_codes: BonusPayment::Bonuses::BuildBonusByPrecalculatedChargeCodes.new,
    calculate_payment_limit: BonusPayment::Bonuses::PaymentLimit.new,
    recalculate: BonusPayment::BonusDetails::Recalculate.new
  )
    @contract = contract
    @precalculate_charge_codes_by_period = precalculate_charge_codes_by_period
    @total_by_precalculated_charge_codes = total_by_precalculated_charge_codes
    @total_by_bonus_details = total_by_bonus_details
    @fetch_managed_users = fetch_managed_users
    @build_bonus_by_precalculated_charge_codes = build_bonus_by_precalculated_charge_codes
    @calculate_payment_limit = calculate_payment_limit
    @recalculate = recalculate
  end

  attr_reader :contract, :precalculate_charge_codes_by_period, :total_by_precalculated_charge_codes,
              :total_by_bonus_details, :fetch_managed_users, :build_bonus_by_precalculated_charge_codes,
              :calculate_payment_limit, :recalculate

  def call(current_user:, params:)
    months, calculation_base_field, allowed_charge_codes, page, per_page, q = prepare_params(
      yield validate_contract(contract, params)
    )
    managed_users = yield fetch_users(current_user:, months:, q:)
    pagy, displayed_users = paginate(collection: managed_users, page:, per_page:)
    precalculated = displayed_users.includes(:scheme, :employment, department: :parent).map do |user|
      precalculate(user:, months:, calculation_base_field:, allowed_charge_codes:)
    end
    Success({ precalculated:, meta: meta(pagy) })
  end

  private

  def prepare_params(valid_params)
    months = valid_params[:months].map {|month| Date.parse(month).beginning_of_month }.uniq.sort
    calculation_base_field = valid_params[:calculation_base_field] || 'bonus_amount_by_charge_code'
    allowed_charge_codes = valid_params[:allow_use_charge_code_in_calculation]&.sort || []
    page = valid_params[:page] || 1
    per_page = valid_params[:per_page] || PER_PAGE
    q = valid_params[:q]

    [months, calculation_base_field, allowed_charge_codes, page, per_page, q]
  end

  def fetch_users(current_user:, months:, q:)
    managed_users = yield fetch_managed_users.call(current_user:)
    managed_users = managed_users.with_salary_in_months(months).with_work_charge_codes.ransack(q).result
    managed_users = User.select('*').from(managed_users).order(surname: :asc, name: :asc, patronymic: :asc)

    managed_users.empty? ? Failure(:users_not_found) : Success(managed_users)
  end

  def precalculate(user:, months:, calculation_base_field:, allowed_charge_codes:)
    operation = precalculate_charge_codes_by_period.call(user:, months:)
    if operation.success?
      precalculated_charge_codes = operation.value!
      precalculated_charge_codes_total = total_by_precalculated_charge_codes.call(
        precalculated_charge_codes:, allowed_charge_codes:
      )
      bonus = find_or_initialize_new_bonus(
        user:, months:, calculation_base_field:, allowed_charge_codes:, precalculated_charge_codes:
      )
      bonus_total = total_by_bonus_details.call(bonus:)
      payment_limit = calculate_payment_limit.call(user:, bonus:)
      precalculated_period = BonusPayment::Bonuses::PrecalculatedPeriod.new(
        user:, bonus:, bonus_total:, payment_limit:, precalculated_charge_codes:, precalculated_charge_codes_total:
      )
      BonusPayment::PrecalculatedPeriodSerializer.new(precalculated_period).to_h
    else
      { user: BonusPayment::Users::UserSerializer.new(user).to_h, error: operation.failure }
    end
  end

  def find_or_initialize_new_bonus(
    user:, months:, calculation_base_field:, allowed_charge_codes:, precalculated_charge_codes:
  )
    bonus = BonusPayment::Bonus.find_by(user:, start_at: months.min, end_at: months.max)
    if bonus.nil?
      bonus = yield build_bonus_by_precalculated_charge_codes.call(
        user:, months:, calculation_base_field:, allowed_charge_codes:, precalculated_charge_codes:
      )
    end

    bonus
  end

  def paginate(collection:, page:, per_page:)
    pagy = Pagy.new(count: collection.count, page:, items: per_page)
    [pagy, collection.offset(pagy.offset).limit(pagy.items)]
  end

  def meta(pagy)
    {
      page: pagy.page,
      next: pagy.next,
      items: pagy.items,
      total: pagy.count,
      last: pagy.last,
      pages: pagy.pages
    }
  end
end
