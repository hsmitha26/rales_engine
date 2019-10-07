require 'rails_helper'

describe "Invoices API" do
  it "can get all invoices" do
    create_list(:invoice, 5)

    get "/api/v1/invoices"

    invoices = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoices["data"].count).to eq(5)
  end

  it "can get an invoice by its id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)
    expect(invoice["data"]["id"]).to eq(id.to_s)
  end
end
