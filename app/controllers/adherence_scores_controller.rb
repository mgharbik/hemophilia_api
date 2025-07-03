class AdherenceScoresController < ApplicationController
  def show
    service = AdherenceScoreService.new(current_patient)
    render json: service.call
  end
end
