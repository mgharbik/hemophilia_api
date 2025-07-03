class ApplicationController < ActionController::API
  before_action :authorize_api_key!

  attr_reader :current_patient

  private

  def authorize_api_key!
    header = request.headers["Authorization"]
    token = header&.split("Bearer ")&.last

    payload = TokenService.decode(token)

    if payload
      patient = Patient.find_by(id: payload[:patient_id])
      if patient&.api_key == payload[:api_key]
        @current_patient = patient
        return
      end
    end

    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
