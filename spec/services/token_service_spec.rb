require "rails_helper"

RSpec.describe TokenService do
  let(:patient) { create(:patient) }
  let(:token) { described_class.encode(patient) }

  describe ".encode" do
    it "generates a JWT token string" do
      expect(token).to be_a(String)
      expect(token.split('.').size).to eq(3) # JWT has 3 parts separated by dots
    end
  end

  describe ".decode" do
    it "decodes a valid token and returns payload with patient_id and api_key" do
      payload = described_class.decode(token)

      expect(payload).to be_a(Hash)
      expect(payload[:patient_id]).to eq(patient.id)
      expect(payload[:api_key]).to eq(patient.api_key)
      expect(payload[:iat]).to be_a(Integer)
    end

    it "returns nil for an invalid token" do
      expect(described_class.decode("invalid.token.string")).to be_nil
    end

    it "returns nil for a nil token" do
      expect(described_class.decode(nil)).to be_nil
    end
  end
end
