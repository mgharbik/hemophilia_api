require "rails_helper"

RSpec.describe Injection, type: :model do
  it { should belong_to(:patient) }

  it { should validate_presence_of(:dose) }
  it { should validate_numericality_of(:dose).is_greater_than(0) }

  it { should validate_presence_of(:lot_number) }
  it { should validate_length_of(:lot_number).is_equal_to(6) }
  it { should allow_value("ABC123").for(:lot_number) }
  it { should_not allow_value("ABC12").for(:lot_number) }
  it { should_not allow_value("abc!@#").for(:lot_number) }

  it { should validate_presence_of(:drug_name) }
  it { should validate_presence_of(:injected_at) }

  describe "#injected_at_after_patient_created_at" do
    let(:patient) { create(:patient) }
    let(:injected_at) { patient.created_at + 1.day }

    subject { build(:injection, patient: patient, injected_at: injected_at) }

    it { is_expected.to be_valid }

    context "when injected_at is before the patient's creation date" do
      let(:injected_at) { patient.created_at - 1.day }

      it { is_expected.to be_invalid }
    end
  end
end
