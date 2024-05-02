class BonusPayment::Actions::Bonuses::UpdateCollection < DryOperation
  def initialize(
    contract: BonusPayment::Actions::Bonuses::UpdateCollectionContract,
    fetch_managed_users: BonusPayment::Users::FetchManagedUsers.new,
    update_collection: BonusPayment::Bonuses::UpdateCollection.new
  )
    @contract = contract
    @fetch_managed_users = fetch_managed_users
    @update_collection = update_collection
  end

  attr_reader :contract, :fetch_managed_users, :update_collection

  def call(current_user:, params:)
    months, calculation_base_field, user_ids, allowed_charge_codes, bonus_detail_attributes,
      update_details_with_charge_code_names = prepare_params(yield validate_contract(contract, params))

    managed_users = yield fetch_users(current_user:, user_ids:, months:)

    managed_users.find_each do |user|
      update_collection.call(
        user:,
        months:,
        calculation_base_field:,
        allowed_charge_codes:,
        bonus_detail_attributes:,
        update_details_with_charge_code_names:
      )
    end

    Success()
  end

  private

  def fetch_users(current_user:, user_ids:, months:)
    managed_users = yield fetch_managed_users.call(current_user:)
    managed_users = managed_users.where(id: user_ids) if user_ids.present?
    managed_users = managed_users.with_salary_in_months(months).with_work_charge_codes

    managed_users.empty? ? Failure(:users_not_found) : Success(managed_users)
  end

  def prepare_params(valid_params)
    allowed_charge_codes = valid_params[:allowed_charge_codes]&.sort || []
    months = valid_params[:months].map {|month| Date.parse(month).beginning_of_month }.uniq.sort
    calculation_base_field = valid_params[:calculation_base_field] || 'bonus_amount_by_charge_code'
    user_ids = valid_params[:user_ids]
    bonus_detail_attributes = valid_params[:bonus_detail_attributes]
    update_details_with_charge_code_names = valid_params[:charge_code_names]

    [
      months,
      calculation_base_field,
      user_ids,
      allowed_charge_codes,
      bonus_detail_attributes,
      update_details_with_charge_code_names
    ]
  end
end
