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

  context "find and find_all" do
    before :each do
      @merchants = create_list(:merchant, 3)
      @merchant_find = @merchants[1]
    end

    it "can find a single merchant for a specific parameter - id" do
      get "/api/v1/merchants/find?id=#{@merchant_find.id}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["id"]).to eq(@merchant_find.id)
    end

    it "can get a single merchant for a specific parameter - name" do
      get "/api/v1/merchants/find?name=#{@merchant_find.name}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["name"]).to eq(@merchant_find.name)
    end

    it "can get all the merchants for a specific parameter - id" do
      get "/api/v1/merchants/find_all?id=#{@merchant_find.id}"

      merchant = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(merchant[0]["attributes"]["id"]).to eq(@merchant_find.id)
    end

    it "can get all the merchants for a specific parameter - name" do
      get "/api/v1/merchants/find_all?name=#{@merchants[1].name}"
      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant[0]["attributes"]["name"]).to eq(@merchants[1].name)
    end
  end

  it "can get a random merchant" do
    merchants = create_list(:merchant, 3)
    get "/api/v1/merchants/random"
    random_merchant = JSON.parse(response.body)

    expect(response).to be_successful
  end

  context "find associations for a single merchant" do
    before :each do
      @merchant_1 = create(:merchant)
      @item1 = create(:item, merchant: @merchant_1)
      @item2 = create(:item, merchant: @merchant_1)
      @invoice1 = create(:invoice, merchant: @merchant_1)
      @invoice2 = create(:invoice, merchant: @merchant_1)


      @merchant_2 = create(:merchant)
      @item3 = create(:item, merchant: @merchant_2)
    end

    it "can get a collection of items associated with a merchant" do
      get "/api/v1/merchants/#{@merchant_1.id}/items"

      merchant_1_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant_1_items.count).to eq(2)
    end

    it "can get a collection of invoices for a specific merchant" do
      get "/api/v1/merchants/#{@merchant_1.id}/invoices"

      merchant_1_invoices = JSON.parse(response.body)
    end
  end
end
