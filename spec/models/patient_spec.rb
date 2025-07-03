require "rails_helper"

RSpec.describe Patient, type: :model do
  it { should have_many(:injections).dependent(:destroy) }

  it { should validate_presence_of(:api_key) }
  it { should validate_presence_of(:treatment_interval_days) }
  it { should validate_numericality_of(:treatment_interval_days).is_greater_than(0) }
end
