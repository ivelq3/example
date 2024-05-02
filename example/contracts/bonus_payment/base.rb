class BonusPayment::Base < Dry::Validation::Contract
  config.messages.default_locale = :ru
  config.messages.load_paths << 'config/locales/bonus_payment.yml'
end
