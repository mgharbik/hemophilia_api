class InjectionsController < ApplicationController
  before_action :authorize_api_key!

  def index
    injections = current_patient.injections.order(injected_at: :desc)
    render json: injections
  end

  def create
    injection = current_patient.injections.build(injection_params)

    if injection.save
      render json: injection, status: :created
    else
      render json: { errors: injection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def injection_params
    params.require(:injection).permit(:dose, :lot_number, :drug_name, :injected_at)
  end
end
