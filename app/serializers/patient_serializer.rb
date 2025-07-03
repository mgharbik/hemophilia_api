class PatientSerializer < ActiveModel::Serializer
  attributes :id, :api_key, :treatment_interval_days
end
