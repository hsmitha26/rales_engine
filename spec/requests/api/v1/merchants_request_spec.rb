require 'rails_helper'

describe 'Merchants API' do
  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)["data"]
    expect(merchants.count).to eq(5)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(id.to_s)
  end

  it "can find a single merchant for a specific parameter - id" do
    merchants = create_list(:merchant, 3)
    merchant_find = merchants[2]
    get "/api/v1/merchants/find?id=#{merchant_find.id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(merchant_find.id)
  end

  it "can get a single merchant for a specific parameter - name" do
    merchants = create_list(:merchant, 3)
    merchant_find = merchants[2]
    get "/api/v1/merchants/find?name=#{merchant_find.name}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq(merchant_find.name)
  end

  it "can get all the merchants for a specific parameter - id" do
    merchants = create_list(:merchant, 3)
    merchant_find = merchants[2]
    get "/api/v1/merchants/find_all?id=#{merchant_find.id}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant[0]["attributes"]["id"]).to eq(merchant_find.id)
  end

  it "can get all the merchants for a specific parameter - name" do
    merchants = create_list(:merchant, 3)
    get "/api/v1/merchants/find_all?name=#{merchants[1].name}"
    merchant = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(merchant[0]["attributes"]["name"]).to eq(merchants[1].name)
  end

  it "can get a random merchant" do
    merchants = create_list(:merchant, 3)
    get "/api/v1/merchants/random"
    random_merchant = JSON.parse(response.body)

    expect(response).to be_successful
  end

  it "can get a collection of items associated with a merchant" do
    merchant_1 = create(:merchant)
    item1 = create(:item, merchant: merchant_1)
    item2 = create(:item, merchant: merchant_1)
    merchant_2 = create(:merchant)
    item3 = create(:item, merchant: merchant_2)
    get '/api/v1/merchants/:id/items'
  end
end
