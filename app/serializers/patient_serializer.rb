class PatientSerializer < ActiveModel::Serializer
  attributes :id, :treatment_interval_days, :token

  def token
    TokenService.encode(object)
  end
end
