require "rails_helper"

RSpec.describe "Injections API", type: :request do
  let(:patient) { create(:patient) }
  let(:token) { TokenService.encode(patient) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /injections" do
    before do
      create_list(:injection, 3, patient: patient)
    end

    it "returns the patient's injections in descending order" do
      get "/injections", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.first).to include("dose", "lot_number", "drug_name", "injected_at")
    end

    it "returns unauthorized if token is missing" do
      get "/injections"

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns unauthorized if token is invalid" do
      get "/injections", headers: { "Authorization" => "Bearer invalidtoken" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /injections" do
    let(:valid_params) do
      {
        injection: {
          dose: 5.0,
          lot_number: "ABC123",
          drug_name: "Factor VIII",
          injected_at: (patient.created_at + 1.day).iso8601
        }
      }
    end

    it "creates an injection with valid params and valid token" do
      expect {
        post "/injections", params: valid_params, headers: headers
      }.to change(Injection, :count).by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["dose"]).to eq(5.0)
      expect(json["lot_number"]).to eq("ABC123")
      expect(json["drug_name"]).to eq("Factor VIII")
      expect(Time.parse(json["injected_at"]).iso8601).to eq(valid_params[:injection][:injected_at])
    end

    it "returns unauthorized if token is missing" do
      post "/injections", params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns unauthorized if token is invalid" do
      post "/injections", params: valid_params, headers: { "Authorization" => "Bearer invalidtoken" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns validation errors with invalid params" do
      invalid_params = {
        injection: {
          dose: nil,
          lot_number: "12", # too short
          drug_name: "",
          injected_at: nil
        }
      }

      post "/injections", params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)

      expect(json["errors"]).to include(
        "Dose can't be blank",
        "Lot number is the wrong length (should be 6 characters)",
        "Drug name can't be blank",
        "Injected at can't be blank"
      )
    end
  end
end
