class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :id, :created_at, :updated_at
end
