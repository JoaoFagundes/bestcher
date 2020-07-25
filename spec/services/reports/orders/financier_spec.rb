require "rails_helper"

describe Reports::Orders::Financier do
  shared_examples "success" do
    it { is_expected.to be_truthy }

    it "returns correct data" do
      expect(subject).to match(expected_return)
    end
  end

  context "with existing orders" do
    let!(:order_1) { create :order, purchase_channel: "Site BR", delivery_service: "SEDEX" }
    let!(:order_2) { create :order, purchase_channel: "Iguatemi Store", delivery_service: "SEDEX" }
    let!(:order_3) { create :order, purchase_channel: "Iguatemi Store", delivery_service: "SEDEX" }
    let!(:order_4) { create :order, purchase_channel: "Site BR", delivery_service: "PAC" }
    let!(:order_5) { create :order, purchase_channel: "Site BR", delivery_service: "PAC" }

    describe "new without params - grouping by reference by default" do
      subject { described_class.new.call }

      include_examples "success" do
        let(:expected_return) do
          [order_1, order_2, order_3, order_4, order_5].map do |order|
            {
              reference: order.reference,
              order_count: 1,
              total_value: order.total_value
            }
          end
        end
      end
    end

    describe "grouping by purchase_channel" do
      subject { described_class.new(group_type: :purchase_channel).call }

      include_examples "success" do
        let(:expected_return) do
          [{
          purchase_channel: "Site BR",
          order_count: 3,
          total_value: [order_1, order_4, order_5].sum(&:total_value)
          },
          {
            purchase_channel: "Iguatemi Store",
            order_count: 2,
            total_value: [order_2, order_3].sum(&:total_value)
          }]
        end
      end
    end

    describe "grouping by delivery_service" do
      subject { described_class.new(group_type: :delivery_service).call }

      include_examples "success" do
        let(:expected_return) do
          [{
            delivery_service: "SEDEX",
            order_count: 3,
            total_value: [order_1, order_2, order_3].sum(&:total_value)
          },
          {
            delivery_service: "PAC",
            order_count: 2,
            total_value: [order_4, order_5].sum(&:total_value)
          }]
        end
      end
    end
  end

  context "without existing orders" do
    describe "new without params - grouping by reference by default" do
      subject { described_class.new.call }

      include_examples "success" do
        let(:expected_return) { [] }
      end
    end

    describe "grouping by purchase_channel" do
      subject { described_class.new(group_type: :purchase_channel).call }

      include_examples "success" do
        let(:expected_return) { [] }
      end
    end

    describe "grouping by delivery_service" do
      subject { described_class.new(group_type: :delivery_service).call }

      include_examples "success" do
        let(:expected_return) { [] }
      end
    end
  end
end
