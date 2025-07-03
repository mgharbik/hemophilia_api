FactoryBot.define do
  factory :injection do
    patient

    dose { 5.0 }
    lot_number { "ABC123" }
    drug_name { "Factor VIII" }
    injected_at { Time.current }
  end
end
