class BonusPayment::Bonuses::TotalByBonusDetails < DryOperation
  Total = Struct.new(
    :calculated_amount,
    :manual_amount,
    :bonus_from_file,
    :payment_amount,
    keyword_init: true
  )

  def call(bonus:)
    if bonus.details.any?(&:current_salary_by_charge_code?)
      allowed_details = bonus.details
    else
      not_use_in_calculation = BonusPayment::ChargeCode::NOT_WORKING_KINDS - bonus.allowed_charge_codes

      allowed_details = bonus.details.filter do |detail|
        next if detail.charge_code.kind.in? not_use_in_calculation

        detail
      end
    end

    calculated_amount = allowed_details.filter_map(&:calculated_amount).sum
    manual_amount = allowed_details.filter_map(&:manual_amount).sum
    bonus_from_file = allowed_details.filter_map(&:bonus_from_file).sum
    payment_amount = allowed_details.filter_map(&:payment_amount).sum

    Total.new(
      calculated_amount:,
      manual_amount:,
      bonus_from_file:,
      payment_amount:
    )
  end
end
