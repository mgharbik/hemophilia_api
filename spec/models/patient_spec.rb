require "rails_helper"

RSpec.describe Patient, type: :model do
  it { should have_many(:injections).dependent(:destroy) }

  it { should validate_presence_of(:treatment_interval_days) }
  it { should validate_numericality_of(:treatment_interval_days).is_greater_than(0) }

  describe "#api_key" do
    it "generates an api_key on creation" do
      patient = create(:patient)
      expect(patient.api_key).to be_present
      expect(patient.api_key.length).to eq(32)
    end
  end
end
