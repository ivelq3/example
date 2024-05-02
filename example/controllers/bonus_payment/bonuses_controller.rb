class BonusPayment::BonusesController < ApplicationController
  def precalculate_period
    authorize! :precalculate_period, BonusPayment::Bonus
    operation = BonusPayment::Actions::Bonuses::PrecalculatePeriod.new.call(
      current_user:, params: params.to_unsafe_h
    )
    if operation.success?
      render json: operation.value!
    else
      render json: operation.failure, status: :unprocessable_entity
    end
  end

  def update_collection
    authorize! :update_collection, BonusPayment::Bonus
    operation = BonusPayment::Actions::Bonuses::UpdateCollection.new.call(
      current_user:, params: params.to_unsafe_h
    )
    if operation.success?
      render json: { success: true }
    else
      render json: { error: operation.failure }, status: :unprocessable_entity
    end
  end
end
