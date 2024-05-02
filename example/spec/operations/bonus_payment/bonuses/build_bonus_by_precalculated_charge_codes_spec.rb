require 'rails_helper'

RSpec.describe BonusPayment::Bonuses::BuildBonusByPrecalculatedChargeCodes do
  subject(:call) do
    described_class.new.call(
      user:,
      months:,
      allowed_charge_codes: [],
      calculation_base_field:,
      precalculated_charge_codes:
    )
  end

  let(:months) { [Date.current.beginning_of_month] }
  let(:calculation_base_field) { 'current_salary_by_charge_code' }
  let(:user) { create(:user) }
  let(:charge_code) { create(:bonus_payment_charge_code) }
  let(:precalculation) {
    BonusPayment::Bonuses::ChargeCodePrecalculation.new(
      time_percent_by_charge_code: 1,
      salary_by_charge_code: 2,
      bonus_amount_by_charge_code: 3,
      current_salary_by_charge_code: 4,
      hours_worked_by_charge_code: 5
    )
  }
  let(:precalculated_charge_codes) {
    [BonusPayment::Bonuses::PrecalculatedChargeCode.new(charge_code:, precalculation:)]
  }

  describe 'bonus' do
    subject(:bonus) { call.value! }

    it 'sets user' do
      expect(bonus.user_id).to eq(user.id)
    end

    it 'sets start_at' do
      expect(bonus.start_at).to eq(months.min)
    end

    it 'sets end_at' do
      expect(bonus.end_at).to eq(months.max)
    end
  end

  describe 'details' do
    subject(:detail) { call.value!.details.first }

    it 'sets calculation_base_field' do
      expect(detail.calculation_base_field).to eq(calculation_base_field)
    end
  end
end
