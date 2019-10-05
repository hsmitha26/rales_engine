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

      it "returns x number of merchants ranked by total revenue" do
        # binding.pry
        expect(Merchant.top_merchant_by_revenue(1)).to eq([@m3])
        expect(Merchant.top_merchant_by_revenue(2)).to eq([@m3, @m2])
        expect(Merchant.top_merchant_by_revenue(3)).to eq([@m3, @m2, @m1])
        expect(Merchant.top_merchant_by_revenue(4)).to eq([@m3, @m2, @m1])
      end
    end
  end
end
