class AdherenceScoreService
  def initialize(patient)
    @patient = patient
  end

  def call
    today = Date.current
    expected_dates = []
    current_date = @patient.created_at.to_date

    while current_date <= today
      expected_dates << current_date
      current_date += @patient.treatment_interval_days
    end

    injection_dates = @patient.injections.pluck(:injected_at).map(&:to_date)
    on_time_count = (expected_dates & injection_dates).size

    {
      expected_injections: expected_dates.size,
      actual_injections: injection_dates.size,
      on_time_injections: on_time_count,
      adherence_score: ((on_time_count.to_f / expected_dates.size) * 100).round
    }
  end
end
