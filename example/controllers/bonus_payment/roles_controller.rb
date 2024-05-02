class BonusPayment::RolesController < ApplicationController
  def current_user_role
    render json: { role: BonusPayment::Role.find_by(user: current_user)&.name }
  end
end
