class BonusPayment::Departments::BlockSerializer
  include Alba::Resource

  root_key :block, :blocks

  attributes :id, :name
  many :children, proc {|children| children.active }, resource: BonusPayment::Departments::BlockSerializer
end
