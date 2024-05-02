require 'swagger_helper'
require 'rails_helper'

describe 'POST /bonus_payment/bonuses/precalculate_period' do
  include_context 'with employee assistant admin'
  let(:month) { Date.current.beginning_of_month }
  let(:timesheet) { create(:bonus_payment_timesheet, user: employee, month:) }

  before do
    create(:bonus_payment_timesheet, user: employee)
    create(:bonus_payment_salary, user: employee, month:)
  end

  path '/bonus_payment/bonuses/precalculate_period' do
    post 'Предрасчитать бонусы за период' do
      tags 'Модуль Бонусов'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          months: { type: :array, required: true, items: { type: :string, example: '01-01-2024' } },
          calculation_base_field: {
            type: :string,
            required: true,
            enum: %w[bonus_amount_by_charge_code current_salary_by_charge_code salary_by_charge_code]
          },
          allow_use_charge_code_in_calculation: {
            type: :array,
            required: false,
            items: { type: :string, example: 'VACATION' }
          },
          q: {
            type: :object,
            required: false,
            properties: {
              full_name_cont: { type: :string, required: false, example: 'Иванов Иван Иванович' },
              id_in: { type: :array, required: false, items: { type: :integer, example: 1 } },
              department_id_in: { type: :array, required: false, items: { type: :integer, example: 2 } },
              timesheets_charge_code_id_in: { type: :array, required: false, items: { type: :integer, example: 3 } }
            }
          }
        }
      }

      response '200', 'Ok' do
        let(:current_user) { assistant }
        let(:payload) do
          {
            months: [month.to_s],
            calculation_base_field: 'bonus_amount_by_charge_code'
          }
        end

        run_test! do
          expect(response.parsed_body['precalculated']).not_to be_empty
        end
      end
    end
  end
end
