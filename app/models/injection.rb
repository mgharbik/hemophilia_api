class Injection < ApplicationRecord
  belongs_to :patient

  validates :dose, presence: true, numericality: { greater_than: 0 }
  validates :lot_number, presence: true, length: { is: 6 }, format: { with: /\A[a-zA-Z0-9]{6}\z/ }
  validates :drug_name, presence: true
  validates :injected_at, presence: true

  validate :injected_at_after_patient_created_at

  private

  def injected_at_after_patient_created_at
    return if injected_at.blank? || patient.blank?

    if injected_at < patient.created_at
      errors.add(:injected_at, "must be after the patient was created")
    end
  end
end
