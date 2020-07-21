require "rails_helper"

describe "V1 - Purchase Channel - Orders", type: :request do
  describe "index" do
    let!(:site_br_batch) { create :batch, purchase_channel: "Site BR" }
    let!(:site_br_closing_orders) { create_list :order, 3, batch: site_br_batch, status: :closing }
    let!(:site_br_ready_orders) { create_list :order, 2, status: :ready }
    let!(:iguatemi_batch) { create :batch, purchase_channel: "Iguatemi Store" }
    let!(:iguatemi_closing_orders) do
      create_list :order, 2, purchase_channel: "Iguatemi Store", batch: iguatemi_batch, status: :closing
    end

    shared_examples "correct status code and data" do
      it "status code is ok" do
        expect(response).to have_http_status(:ok)
      end

      it "data is correct" do
        expect(JSON.parse(response.body)["data"]).to match(data)
      end

      it "request is success" do
        expect(JSON.parse(response.body)["success"]).to eq(true)
      end
    end

    shared_examples "from specific status" do
      Order::STATUSES.each do |status|
        context "#{status} orders" do
          let(:params) { { status: status.to_s } }

          before { get "/v1/purchase_channel/#{CGI.escape(purchase_channel)}/orders", params: params }

          include_examples "correct status code and data" do
            let(:data) { send("#{status}_orders")}
          end
        end
      end
    end

    context "success" do
      context "retrieve site br orders" do
        let(:purchase_channel) { "Site BR" }

        include_examples "from specific status" do
          let(:ready_orders) { JSON.parse(Order.find(site_br_ready_orders.pluck(:id)).to_json) }
          let(:production_orders) { [] }
          let(:closing_orders) { JSON.parse(Order.find(site_br_closing_orders.pluck(:id)).to_json) }
          let(:sent_orders) { [] }
        end

        context "from any status" do
          before { get "/v1/purchase_channel/#{CGI.escape(purchase_channel)}/orders" }

          include_examples "correct status code and data" do
            let!(:data) { JSON.parse(Order.where(purchase_channel: purchase_channel).to_json) }
          end
        end
      end

      context "retrieve iguatemi orders" do
        let(:purchase_channel) { "Iguatemi Store" }

        include_examples "from specific status" do
          let(:ready_orders) { [] }
          let(:production_orders) { [] }
          let(:closing_orders) { JSON.parse(Order.find(iguatemi_closing_orders.pluck(:id)).to_json) }
          let(:sent_orders) { [] }
        end

        context "from any status" do
          before { get "/v1/purchase_channel/#{CGI.escape(purchase_channel)}/orders" }

          include_examples "correct status code and data" do
            let(:data) { JSON.parse(Order.where(purchase_channel: purchase_channel).to_json) }
          end
        end
      end
    end
  end
end
