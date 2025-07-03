require "rails_helper"

RSpec.describe "Adherence Score API", type: :request do
  let(:patient) { create(:patient, treatment_interval_days: 3, created_at: 12.days.ago) }
  let(:token) { TokenService.encode(patient) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  it "returns adherence details with correct calculations" do
    # expected injections = 5 (days 0,3,6,9,12)
    create(:injection, patient: patient, injected_at: 12.days.ago) # On time for first dose
    create(:injection, patient: patient, injected_at: 10.days.ago) # Early
    create(:injection, patient: patient, injected_at: 5.days.ago) # Late
    create(:injection, patient: patient, injected_at: 2.days.ago) # Late

    get "/adherence_score", headers: headers

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)

    expect(json).to include(
      "expected_injections" => 5,
      "actual_injections" => 4,
      "on_time_injections" => 1,
      "adherence_score" => 20
    )
  end

  it "returns unauthorized if token is missing" do
    get "/adherence_score"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns unauthorized if token is invalid" do
    get "/adherence_score", headers: { "Authorization" => "Bearer invalidtoken" }
    expect(response).to have_http_status(:unauthorized)
  end
end
