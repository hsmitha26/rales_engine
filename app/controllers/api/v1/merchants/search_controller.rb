class Api::V1::Merchants::SearchController < ApplicationController
  def show
    find_params = search_params.keys.first
    render json: MerchantSerializer.new(Merchant.find_by("#{find_params} = ?", params[find_params]))
  end

  def index
    render json: MerchantSerializer.new(Merchant.where(search_params))
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
