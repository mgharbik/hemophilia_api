class PatientsController < ApplicationController
  skip_before_action :authorize_api_key!

  def create
    patient = Patient.new(patient_params)

    if patient.save
      render json: patient, status: :created
    else
      render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:treatment_interval_days)
  end
end
