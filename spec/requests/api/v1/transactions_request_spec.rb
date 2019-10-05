require 'rails_helper'

describe 'Trasactions API' do
  it "sends a list of transactions" do
    create_list(:transaction, 5)
    get '/api/v1/transactions'
    transactions = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(transactions.count).to eq(5)
  end

  it "sends a transaction by its id" do
    id = create(:transaction).id
    get "/api/v1/transactions/#{id}"
    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"].to_i).to eq(id)
  end
end
