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
      @invoice3 = create(:invoice, merchant: @merchant_2)
    end

    it "can get a collection of items associated with a merchant" do
      get "/api/v1/merchants/#{@merchant_1.id}/items"

      merchant_1_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant_1_items.count).to eq(2)
    end

    it "can get a collection of invoices for a specific merchant" do
      get "/api/v1/merchants/#{@merchant_1.id}/invoices"

      merchant_1_invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant_1_invoices.count).to eq(2)
    end
  end

  context "Merchant Business Intelligence" do
    before :each do
      #@c2 doesn't have any invoices
      @c1, @c2 = create_list(:customer, 2)

      #merchant 5 does not have any items
      #3 items for merchants 1-4
      #invoices for merchants 1-3 only. Merchant 4 does not have any invoices
      @m1, @m2, @m3, @m4, @m5 = create_list(:merchant, 5)

      #item_price: @i11 = 2.0, @i12 = 3.0, @i13 = 4.0
      #unit_price: @ii11 = 2.0 - shipped, @ii12 = 3.0 - pending.
      #quantity: @ii11 = 2, @ii12 = 3
      @i11, @i12, @i13 = create_list(:item, 3, merchant: @m1)
        @in11, @in12 = create_list(:invoice, 2, customer: @c1, merchant: @m1)
        @in13 = create(:invoice, customer: @c1, merchant: @m1, status: "pending")
          @ii11 = create(:invoice_item, item: @i11, invoice: @in11)
          @ii12 = create(:invoice_item, item: @i13, invoice: @in13)
      #item_price: @i21 = 5.0, @i22 = 6.0, @i23 = 7.0
      #unit_price: @ii21 = 4.0 , @ii22 = 5.0; both shipped
      #quantity: @ii21 = 4, @ii22 = 5
      @i21, @i22, @i23 = create_list(:item, 3, merchant: @m2)
          @in21, @in22 = create_list(:invoice, 2, customer: @c1, merchant: @m2)
            @ii21 = create(:invoice_item, item: @i21, invoice: @in21)
            @ii22 = create(:invoice_item, item: @i22, invoice: @in22 )
      #item_price: @i31 = 8.0, @i32 = 9.0, @i33 = 10.0
      #unit_price: @ii31 = 6.0 , @ii32 = 7.0; both shipped
      #quantity: @ii31 = 6, @ii32 = 7
      @i31, @i32, @i33 = create_list(:item, 3, merchant: @m3)
          @in31, @in32 = create_list(:invoice, 2, customer: @c1, merchant: @m3)
            @ii31 = create(:invoice_item, item: @i31, invoice: @in31)
            @ii32 = create(:invoice_item, item: @i32, invoice: @in32)
      #item_price: @i41 = 11.0, @i42 = 12.0
      @i41, @i42, @i43 = create_list(:item, 3, merchant: @m4)

      #transactions
      @t11 = create(:transaction, invoice: @in13, result: "Failed")
      @t12 = create(:transaction, invoice: @in11)
      @t21 = create(:transaction, invoice: @in21, result: "Failed")
      @t22 = create(:transaction, invoice: @in22)
      @t31 = create(:transaction, invoice: @in31)
      # @t32 = create(:transaction, invoice: @in32)
    end

    it "returns the top x merchants ranked by total revenue" do
      get "/api/v1/merchants/most_revenue?quantity=3"
      result = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(result.count).to eq(3)
      expect(result.first["id"].to_i).to eq(@m3.id)
    end

    it "returns the top x merchants ranked by total items sold" do
      get "/api/v1/merchants/most_items?quantity=2"
      result = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(result.count).to eq(2)
    end
  end
end
