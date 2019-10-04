require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  context "Merchant business intelligence endpoints" do
    describe "class methods" do
      before :each do
        @merchant_1 = create(:merchant)
        @item11 = create(:item, merchant: @merchant_1)
        @item12 = create(:item, merchant: @merchant_1)
        @invoice11 = create(:invoice, merchant: @merchant_1)
        @invoice12 = create(:invoice, merchant: @merchant_1)
        @invoice_item1 = create(:invoice_item, invoice: @invoice11, item: @item11, quantity: 1)
        @transaction11 = create(:transaction, invoice: @invoice11)
        @transaction12 = create(:transaction, invoice: @invoice12, result: "failed")

        @merchant_2 = create(:merchant)
        @item21 = create(:item, merchant: @merchant_2)
        @item22 = create(:item, merchant: @merchant_2)
        @invoice21 = create(:invoice, merchant: @merchant_2)
        @invoice22 = create(:invoice, merchant: @merchant_2)
        @transaction21 = create(:transaction, invoice: @invoice21)

        @merchant_3 = create(:merchant)
        @item31 = create(:item, merchant: @merchant_3)
        @item32 = create(:item, merchant: @merchant_3)
        @invoice31 = create(:invoice, merchant: @merchant_3)
        @invoice32 = create(:invoice, merchant: @merchant_3)
      end

      it "returns x number of merchants ranked by total revenue" do
        binding.pry
      end
    end
  end
end
