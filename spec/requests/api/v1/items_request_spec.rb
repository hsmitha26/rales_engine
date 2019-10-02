require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 5)

    get "/api/v1/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful

    expect(items["data"].count).to eq(5)
  end
end
