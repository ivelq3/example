class BonusPayment::UserPreferences::UserPreferencesSerializer
  include Alba::Resource

  root_key :user_preferences

  attributes :id, :user_id, :last, :preferences
  attribute :months, &:period
end
