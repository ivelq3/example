class BonusPayment::ChargeCode < ApplicationRecord
  NOT_WORKING_KINDS = %w[
    LEAVE
    PERSEDU
    ADMIN
    UNPAIDVAC
    NOTWORK
    SICK
    GENEDU
    FREE
    VACATION
    UNASSIGN
    UNIVERSAL
  ].freeze

  has_many :timesheets, dependent: :nullify
  has_many :details, dependent: :nullify,
                     class_name: 'BonusPayment::BonusDetail',
                     inverse_of: :charge_code

  validates :external_uid, presence: true
  validates :external_uid, uniqueness: true
end
