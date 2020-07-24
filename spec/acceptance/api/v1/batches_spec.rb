require "rails_helper"

describe "V1 - Batches", type: :request do
  describe "create" do
    let!(:orders) { create_list :order, 3, purchase_channel: "Site BR" }

    shared_examples "correct status code and success status" do |status, success|
      before { post "/v1/batches", params: params }

      it "status code is #{status}" do
        expect(response).to have_http_status(status)
      end

      it "success status is #{success}" do
        expect(JSON.parse(response.body)["success"]).to eq(success)
      end
    end

    context "success" do
      let(:params) { { purchase_channel: CGI.escape("#{orders.sample.purchase_channel}") } }
      let(:batch) { orders.sample.reload.batch }

      include_examples "correct status code and success status", :created, true

      it "correct batch reference" do
        expect(JSON.parse(response.body)["data"]["reference"]).to eq(batch.reference)
      end

      it "correct order count" do
        expect(JSON.parse(response.body)["data"]["order_count"]).to eq(orders.size)
      end
    end

    context "failure" do
      context "missing params" do
        let(:params) { { } }

        include_examples "correct status code and success status", :unprocessable_entity, false

        it "correct error message" do
          expect(JSON.parse(response.body)["errors"]).to include("Purchase channel can't be blank")
        end
      end

      context "no orders from specified purchase channel" do
        let(:params) { { purchase_channel: CGI.escape("Iguatemi Store") } }

        include_examples "correct status code and success status", :unprocessable_entity, false

        it "correct error message" do
          expect(JSON.parse(response.body)["errors"]).to include("The specified purchase channel has no orders.")
        end
      end
    end
  end
end
