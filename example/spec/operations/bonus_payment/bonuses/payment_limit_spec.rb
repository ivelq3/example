require 'rails_helper'

RSpec.describe BonusPayment::Bonuses::PaymentLimit do
  subject(:call) do
    described_class.new.call(user: employee, bonus: draft_bonus)
  end

  include_context 'with employee assistant admin' do
    let(:employee) { create(:user, department:, scheme:) }
  end

  let(:scheme) { create(:bonus_payment_scheme, limit: 10) }
  let(:employee_salary) { 10_000 }
  let(:current_fin_year) { BonusPayment::FinYearHelper.new.fin_year_start_from_date(Date.current) }
  let(:prev_fin_year) { current_fin_year - 1.year }
  let(:draft_bonus) { build(:bonus_payment_bonus, user: employee) }
  let(:draft_detail_by_current_year) {
    build(:bonus_payment_bonus_detail, bonus: draft_bonus, payment_amount: 1000, fin_year: current_fin_year)
  }
  let(:draft_detail_by_prev_year) {
    build(:bonus_payment_bonus_detail, bonus: draft_bonus, payment_amount: 1000, fin_year: prev_fin_year)
  }

  before do
    create(:bonus_payment_salary, user: employee, salary: employee_salary)
  end

  context 'when scheme nil' do
    let(:scheme) { nil }

    it 'returns nil limit' do
      expect(call.limit).to be_nil
    end

    it 'returns nil exit_from_limit' do
      expect(call.exit_from_limit).to be_nil
    end
  end

  context 'when paid bonus exist' do
    let(:paid_bonus) { create(:bonus_payment_bonus, user: employee, state: :paid) }

    before do
      create(:bonus_payment_bonus_detail, bonus: paid_bonus, payment_amount: 101_000, fin_year: current_fin_year)
      create(:bonus_payment_bonus_detail, bonus: paid_bonus, payment_amount: 101_000, fin_year: prev_fin_year)
    end

    it 'returns correct limit' do
      expect(call.limit).to eq(100_000)
    end

    it 'returns correct exit_from_limit' do
      expect(call.exit_from_limit).to eq(-1000)
    end
  end

  context 'when paid bonus not exist' do
    it 'returns correct limit' do
      expect(call.limit).to eq(100_000)
    end

    it 'returns correct exit_from_limit' do
      expect(call.exit_from_limit).to eq(100_000)
    end
  end
end
