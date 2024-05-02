class BonusPayment::PaymentLimitSerializer
  include Alba::Resource

  attribute :limit do |payment_limit|
    params[:round] ? payment_limit.limit&.round : payment_limit.limit
  end

  attribute :exit_from_limit do |payment_limit|
    params[:round] ? payment_limit.exit_from_limit&.round : payment_limit.exit_from_limit
  end
end
