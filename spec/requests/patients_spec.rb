require "rails_helper"

RSpec.describe "Patients API", type: :request do
  describe "POST /patients" do
    let(:valid_params) do
      {
        patient: {
          treatment_interval_days: 3
        }
      }
    end

    context "with valid parameters" do
      it "creates a new patient" do
        expect {
          post "/patients", params: valid_params
        }.to change(Patient, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)

        expect(json["id"]).to be_present
        expect(json["api_key"]).to be_present
        expect(json["treatment_interval_days"]).to eq(3)
      end
    end

    context "with invalid parameters" do
      it "returns errors" do
        post "/patients", params: { patient: { treatment_interval_days: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["errors"]).to include("Treatment interval days can't be blank")
      end
    end
  end
end
