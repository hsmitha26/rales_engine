require 'rails_helper'

describe "Invoices API" do
  it "can get all invoices" do
    create_list(:invoice, 5)

    get "/api/v1/invoices"

    invoices = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoices["data"].count).to eq(5)
  end
end
