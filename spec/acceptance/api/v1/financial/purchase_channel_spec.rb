require "rails_helper"

describe "V1 - Financial - Purchase Channel", type: :request do
  shared_examples "response ok" do
    before { get "/v1/financial/purchase_channel" }

    it "status code is ok" do
      expect(response).to have_http_status(:success)
    end

    it "returns correct data" do
      expect(JSON.parse(response.body)).to eq(data)
    end
  end

  describe "index" do
    context "without orders" do
      include_examples "response ok" do
        let(:data) { [] }
      end
    end

    context "with orders" do
      let(:total_value) { 50.0 }
      let(:number_of_orders) { 3 }
      let!(:order_list) { create_list :order, number_of_orders, total_value: total_value }

      context "only one purchase channel" do
        include_examples "response ok" do
          let!(:data) do
            [
              {
                "purchase_channel" => order_list.sample.purchase_channel,
                "order_count" => number_of_orders,
                "total_value" => (number_of_orders * total_value).to_s
              }
            ]
          end
        end
      end

      context "multiple purchase channel" do
        let!(:another_channel_order) { create :order, total_value: 50, purchase_channel: "Iguatemi Store" }

        include_examples "response ok" do
          let!(:data) do
            [
              {
                "purchase_channel" => order_list.sample.purchase_channel,
                "order_count" => number_of_orders,
                "total_value" => (number_of_orders * total_value).to_s
              },
              {
                "purchase_channel" => another_channel_order.purchase_channel,
                "order_count" => 1,
                "total_value" => "50.0"
              }
            ]
          end
        end
      end
    end
  end
end
