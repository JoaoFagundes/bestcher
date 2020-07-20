require "rails_helper"

describe "V1 - Order Statuses", type: :request do
  describe "show" do
    shared_examples "code and order status" do |code, status|
      it "status code is #{code}" do
        expect(response).to have_http_status(code)
      end

      it "order status is #{status}" do
        expect(JSON.parse(response.body)["data"].pluck("status")).to eq(status)
      end
    end

    shared_examples "order not found" do
      it "status is not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "response body empty" do
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    before { get "/v1/order_status", params: params }

    context "success" do
      let!(:order) { create :order, status: :ready }

      context "with reference" do
        let(:params) { { reference_id: order.reference } }

        include_examples "code and order status", :ok, ["ready"]
      end

      context "with name" do
        let(:params) { { client_name: order.client } }

        context "single order" do
          include_examples "code and order status", :ok, ["ready"]
        end

        context "multiple orders" do
          let!(:closing_orders) { create_list :order, 2, status: :closing, client: order.client, batch: create(:batch) }

          before { get "/v1/order_status", params: params }

          include_examples "code and order status", :ok, ["ready", "closing", "closing"]
        end
      end
    end

    context "failure" do
      before { get "/v1/order_status", params: params }

      context "missing params" do
        let(:params) { { } }

        include_examples "order not found"
      end

      context "reference doesnt exist" do
        let(:params) { { reference_id: "abcdef"} }

        include_examples "order not found"
      end

      context "client doesnt exist" do
        let(:params) { { client_name: "abcdef"} }

        include_examples "order not found"
      end
    end
  end
end
