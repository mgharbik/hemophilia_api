FactoryBot.define do
  factory :patient do
    api_key { SecureRandom.hex(16) }
    treatment_interval_days { 3 }
  end
end
