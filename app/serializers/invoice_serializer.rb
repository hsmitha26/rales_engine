class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :merchant_id, :customer_id, :id
end
