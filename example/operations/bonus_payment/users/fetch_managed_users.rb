class BonusPayment::Users::FetchManagedUsers < DryOperation
  def call(current_user:)
    if current_user.has_bonus_module_role?(BonusPayment::Role::ROLES[:admin])
      Success(User.not_blocked)
    elsif current_user.has_bonus_module_role?(BonusPayment::Role::ROLES[:assistant])
      Success(
        User.not_blocked.joins(department: :parent).where(department: { parent_id: current_user.department.parent_id })
      )
    else
      Failure(:without_role)
    end
  end
end
