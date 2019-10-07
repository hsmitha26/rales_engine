class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.top_merchant_by_items_sold(params[:quantity]))
  end
end
