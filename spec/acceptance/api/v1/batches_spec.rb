require "rails_helper"

describe "V1 - Orders", type: :request do
  describe "create" do
    let!(:orders) { create_list :order, 3, purchase_channel: "Site BR" }

    shared_examples "status code and data success" do |status, success|
      before { post "/v1/batches", params: params }

      it "status code is #{status}" do
        expect(response).to have_http_status(status)
      end

      it "data success is #{success}" do
        expect(JSON.parse(response.body)["success"]).to eq(success)
      end
    end

    context "success" do
      let(:params) { { purchase_channel: CGI.escape("#{orders.sample.purchase_channel}") } }

      include_examples "status code and data success", :created, true
    end

    context "failure" do
      context "missing params" do
        let(:params) { { } }

        include_examples "status code and data success", :unprocessable_entity, false

        it "correct error message" do
          expect(JSON.parse(response.body)["errors"]).to include("Purchase channel can't be blank")
        end
      end

      context "no orders from specified purchase channel" do
        let(:params) { { purchase_channel: CGI.escape("Iguatemi Store") } }

        include_examples "status code and data success", :unprocessable_entity, false

        it "correct error message" do
          expect(JSON.parse(response.body)["errors"]).to include("The specified purchase channel has no orders.")
        end
      end
    end
  end
end
