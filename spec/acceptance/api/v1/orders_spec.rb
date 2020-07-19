require "rails_helper"

describe "V1 - Orders", type: :request do
  describe "create" do
    shared_examples "status code and data success" do |status, success|
      it "status code is #{status}" do
        expect(response).to have_http_status(status)
      end

      it "data success is #{success}" do
        expect(JSON.parse(response.body)["success"]).to eq(success)
      end
    end

    before { post "/v1/orders", params: params }

    context "success" do
      let(:params) do
        {
          reference: "BR102030",
          purchase_channel: "Site BR",
          client: "São Clênio",
          address: "Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250",
          delivery_service: "SEDEX",
          total_value: 123.30,
          line_items: [{ "sku" => "case-my-best-friend" }]
        }
      end

      include_examples 'status code and data success', :created, true
    end

    context "failure" do
      context "missing params" do
        let(:params) do
          {
            reference: "BR102030",
            client: "São Clênio",
            address: "Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250",
            delivery_service: "SEDEX",
            total_value: 123.30,
            line_items: [{ "sku" => "case-my-best-friend" }]
          }
        end

        include_examples 'status code and data success', :unprocessable_entity, false

        it 'correct error message' do
          expect(JSON.parse(response.body)["errors"]).to include("Purchase channel can't be blank")
        end
      end
    end
  end
end
