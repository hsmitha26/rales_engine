class Api::V1::Merchants::MostRevenueController < ApplicationController
    def index
      render json: MerchantSerializer.new(Merchant.top_merchant_by_revenue(params["quantity"]))
    end
end
