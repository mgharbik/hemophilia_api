class Patient < ApplicationRecord
  has_many :injections, dependent: :destroy

  validates :api_key, presence: true
  validates :treatment_interval_days, presence: true, numericality: { greater_than: 0 }
end
