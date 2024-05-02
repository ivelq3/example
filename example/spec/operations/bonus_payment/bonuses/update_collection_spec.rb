require 'rails_helper'

RSpec.describe BonusPayment::Bonuses::UpdateCollection do
  subject(:call) do
    described_class.new.call(
      user: employee,
      months: [month],
      calculation_base_field:,
      allowed_charge_codes: [],
      bonus_detail_attributes:,
      update_details_with_charge_code_names: nil
    )
  end

  include_context 'with employee assistant admin'
  let(:month) { Date.current.beginning_of_month }
  let(:calculation_base_field) { 'current_salary_by_charge_code' }
  let(:bonus_detail_attributes) { { contribution: 1.1 } }
  let(:timesheet) { create(:bonus_payment_timesheet, user: employee, month:, charge_code:) }
  let(:charge_code) { create(:bonus_payment_charge_code, name: 'work', kind: charge_code_kind) }
  let(:charge_code_kind) { 'work' }

  before do
    create(:bonus_payment_salary, user: employee, month:)
    timesheet
  end

  context 'when all preconditions are met' do
    it { is_expected.to be_success }

    context 'when bonus not exist' do
      it 'creates bonus' do
        expect { call }.to change(BonusPayment::Bonus, :count).by(1)
      end

      it 'creates bonus details' do
        expect { call }.to change(BonusPayment::BonusDetail, :count).by(1)
      end
    end

    it 'updates bonus detail' do
      call
      bonus_detail = BonusPayment::BonusDetail.last
      expect(bonus_detail).to have_attributes(bonus_detail_attributes)
    end

    it 'recalculates bonus detail' do
      call
      bonus_detail = BonusPayment::BonusDetail.last
      recalculated_attributes = BonusPayment::BonusDetails::Recalculate.new.call(bonus_detail:).attributes
      expect(bonus_detail).to have_attributes(recalculated_attributes)
    end
  end
end
