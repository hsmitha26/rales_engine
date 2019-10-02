require 'rails_helper'

describe "InvoiceItems API" do
  it "can get all InvoiceItems" do
    create_list(:invoice_item, 5)

    get "/api/v1/invoice_items"

    invoice_items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_items["data"].count).to eq(5)
  end
end
