class BonusPayment::Schemes::SchemeSerializer
  include Alba::Resource

  root_key :scheme, :schemes

  attributes :id, :code, :name, :limit
end
