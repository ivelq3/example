require 'rails_helper'

RSpec.describe BonusPayment::BonusDetails::Recalculate do
  subject(:recalculate) { described_class.new.call(bonus_detail:) }

  let(:bonus_detail) do
    create(
      :bonus_payment_bonus_detail,
      calculation_base_field:,
      kpi:,
      contribution:,
      overwork: 0,
      quantity_salary: 0,
      bonus_from_file:,
      manual_amount:,
      bonus_amount_by_charge_code: 100,
      current_salary_by_charge_code: 200,
      salary_by_charge_code: 300,
      calculated_amount: nil,
      payment_amount: nil
    )
  end

  let(:calculation_base_field) { 'bonus_amount_by_charge_code' }
  let(:kpi) { 0 }
  let(:contribution) { 0 }
  let(:bonus_from_file) { nil }
  let(:manual_amount) { nil }

  describe '.calculated_amount' do
    context 'when calculation_base_field is bonus_amount_by_charge_code' do
      let(:calculation_base_field) { 'bonus_amount_by_charge_code' }

      context 'when coefficients zero' do
        it 'recalculates by bonus_amount_by_charge_code' do
          expect(recalculate.calculated_amount).to eq bonus_detail.bonus_amount_by_charge_code
        end
      end

      context 'when coefficients present' do
        let(:kpi) { 2 }
        let(:contribution) { 2 }

        it 'recalculates by bonus_amount_by_charge_code and apply coefficients' do
          expect(recalculate.calculated_amount).to eq bonus_detail.bonus_amount_by_charge_code * (kpi + contribution)
        end
      end
    end

    context 'when calculation_base_field is current_salary_by_charge_code' do
      let(:calculation_base_field) { 'current_salary_by_charge_code' }

      context 'when coefficients zero' do
        it 'recalculates by current_salary_by_charge_code' do
          expect(recalculate.calculated_amount).to eq bonus_detail.current_salary_by_charge_code
        end
      end

      context 'when coefficients present' do
        let(:kpi) { 2 }
        let(:contribution) { 2 }

        it 'recalculates by current_salary_by_charge_code and apply coefficients' do
          expect(recalculate.calculated_amount).to eq bonus_detail.current_salary_by_charge_code * (kpi + contribution)
        end
      end
    end

    context 'when calculation_base_field is salary_by_charge_code' do
      let(:calculation_base_field) { 'salary_by_charge_code' }

      context 'when coefficients zero' do
        it 'recalculates by salary_by_charge_code' do
          expect(recalculate.calculated_amount).to eq bonus_detail.salary_by_charge_code
        end
      end

      context 'when coefficients present' do
        let(:kpi) { 2 }
        let(:contribution) { 2 }

        it 'recalculates by salary_by_charge_code and apply coefficients' do
          expect(recalculate.calculated_amount).to eq bonus_detail.salary_by_charge_code * (kpi + contribution)
        end
      end
    end

    describe '.payment_amount' do
      context 'when bonus_from_file and manual_amount nil' do
        it 'returns value from calculated_amount' do
          expect(recalculate.payment_amount).to eq(bonus_detail.calculated_amount)
        end
      end

      context 'when bonus_from_file and manual_amount present' do
        let(:bonus_from_file) { 1 }
        let(:manual_amount) { 2 }

        it 'returns value from bonus_from_file' do
          expect(recalculate.payment_amount).to eq(bonus_from_file)
        end
      end

      context 'when only bonus_from_file present' do
        let(:bonus_from_file) { 1 }

        it 'returns value from bonus_from_file' do
          expect(recalculate.payment_amount).to eq(bonus_from_file)
        end
      end

      context 'when only manual_amount present' do
        let(:manual_amount) { 2 }

        it 'returns value from manual_amount' do
          expect(recalculate.payment_amount).to eq(manual_amount)
        end
      end
    end
  end
end
