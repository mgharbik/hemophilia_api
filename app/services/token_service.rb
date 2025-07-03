class TokenService
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(patient)
    payload = {
      patient_id: patient.id,
      api_key: patient.api_key,
      iat: Time.current.to_i
    }

    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    decoded.first.symbolize_keys
  rescue JWT::DecodeError
    nil
  end
end
