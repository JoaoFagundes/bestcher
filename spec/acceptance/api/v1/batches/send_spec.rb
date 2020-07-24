require "rails_helper"

describe "V1 - Batches - Send", type: :request do
  describe "create" do
    let(:batch) { create :batch }
    let!(:orders) { create_list :order, 3, status: :closing, batch: batch }

    shared_examples "correct status code and success status" do |status, success|
      before { post "/v1/batches/#{try(:batch_reference) || batch.reference}/send", params: params }

      it "status code is #{status}" do
        expect(response).to have_http_status(status)
      end

      it "success status is #{success}" do
        expect(JSON.parse(response.body)["success"]).to eq(success)
      end
    end

    shared_examples "correct error message" do |message|
      it { expect(JSON.parse(response.body)["errors"]).to include(message) }
    end

    context "success" do
      let(:params) { { delivery_service: orders.sample.delivery_service } }

      include_examples "correct status code and success status", :ok, true
    end

    context "failure" do
      let(:params) { { delivery_service: orders.sample.delivery_service } }

      context "reference from inexistent batch" do
        include_examples "correct status code and success status", :not_found, false do
          let(:batch_reference) { "inexistent_batch123" }
        end

        include_examples "correct error message", "Batch not found"
      end

      context "missing params" do
        let(:params) { { } }

        include_examples "correct status code and success status", :unprocessable_entity, false

        include_examples "correct error message", "Delivery service can't be blank"
      end

      context "orders are not in closing status" do
        let(:params) { { delivery_service: orders.sample.delivery_service } }

        before { orders.each {|order| order.update_attribute(:status, :production) } }

        include_examples "correct status code and success status", :unprocessable_entity, false

        include_examples "correct error message", "Can't change from production to sent."
      end
    end
  end
end
