class InjectionSerializer < ActiveModel::Serializer
  attributes :id, :dose, :lot_number, :drug_name, :injected_at
end
