require 'rails_helper'

RSpec.describe BonusPayment::Bonuses::TotalByBonusDetails do
  subject(:call) do
    described_class.new.call(bonus:)
  end

  include_context 'with employee assistant admin'

  let(:work_charge_code) { build(:bonus_payment_charge_code, kind: 'WORK') }
  let(:vacation_charge_code) { build(:bonus_payment_charge_code, kind: 'VACATION') }
  let(:allowed_charge_codes) { [] }
  let(:bonus) { build(:bonus_payment_bonus, user: employee, allowed_charge_codes:) }
  let(:calculation_base_field) { 'bonus_amount_by_charge_code' }
  let(:work_detail) {
    build(:bonus_payment_bonus_detail, bonus:, payment_amount: 1000, charge_code: work_charge_code, calculation_base_field:)
  }
  let(:vacation_detail) {
    build(:bonus_payment_bonus_detail, bonus:, payment_amount: 2000, charge_code: vacation_charge_code, calculation_base_field:)
  }

  before do
    work_detail
    vacation_detail
  end

  context 'when allowed_charge_codes empty' do
    it 'skips details by default black list (not working charge codes)' do
      expect(call.payment_amount).to eq(work_detail.payment_amount)
    end
  end

  context 'when allowed_charge_codes present' do
    let(:allowed_charge_codes) { [vacation_charge_code.kind] }

    it 'skips details by default black list - allowed_charge_codes' do
      expect(call.payment_amount).to eq(work_detail.payment_amount + vacation_detail.payment_amount)
    end
  end

  context 'when allowed_charge_codes empty and calculaion_base_field current_salary_by_charge_code' do
    let(:calculation_base_field) { 'current_salary_by_charge_code' }

    it 'sum total by all details' do
      expect(call.payment_amount).to eq(work_detail.payment_amount + vacation_detail.payment_amount)
    end
  end
end
