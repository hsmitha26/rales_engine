require 'rails_helper'

describe "InvoiceItems API" do
  it "can get all InvoiceItems" do
    create_list(:invoice_item, 5)

    get "/api/v1/invoice_items"

    invoice_items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_items["data"].count).to eq(5)
  end

  it "can get one InvoiceItem by its id" do
    id = create(:invoice_item).id
    get "/api/v1/invoice_items/#{id}"
    invoice_item = JSON.parse(response.body)["data"]["id"]

    expect(response).to be_successful
    expect(invoice_item.to_i).to eq(id)
  end
end
