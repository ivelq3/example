class BonusPayment::Bonuses::BonusSerializer
  include Alba::Resource

  root_key :bonus, :bonuses

  attributes :id, :user_id, :scheme_id, :amount, :start_at, :end_at, :allowed_charge_codes
  many :details, resource: BonusPayment::BonusDetails::BonusDetailSerializer
end
