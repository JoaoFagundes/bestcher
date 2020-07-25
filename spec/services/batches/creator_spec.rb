require "rails_helper"

describe Batches::Creator do
  subject { described_class.new("Site BR").call }

  let!(:site_br_orders) { create_list :order, 4, purchase_channel: "Site BR" }
  let!(:iguatemi_orders) { create_list :order, 2, purchase_channel: "Iguatemi Store" }

  shared_examples "failure" do |error|
    it { is_expected.to be_falsy }

    it "doesnt create batch" do
      expect { subject }.not_to change { Batch.count }
    end

    context "unsafe method raises error" do
      subject { described_class.new(nil).call! }

      it { expect { subject }.to raise_error(error) }
    end
  end

  context "success" do
    it { is_expected.to be_truthy }

    it "creates a batch" do
      expect { subject }.to change { Batch.count }.by(1)
    end

    it "returns batch correctly" do
      expect(subject).to have_attributes({ purchase_channel: site_br_orders.sample.purchase_channel })
    end

    context "update orders from specified purchase channel" do
      it "status" do
        expect { subject }
          .to change { site_br_orders.map(&:reload).pluck(:status) }
          .from(["ready"] * site_br_orders.size)
          .to(["production"] * site_br_orders.size)
      end

      it "batches" do
        expect { subject }
          .to change { site_br_orders.map(&:reload).pluck(:batch_id) }
          .from([nil] * site_br_orders.size)
      end
    end

    context "doesnt update orders from others purchase channels" do
      it "status" do
        expect { subject }
          .not_to change { iguatemi_orders.map(&:reload).pluck(:status) }
          .from(["ready"] * iguatemi_orders.size)
      end

      it "batches" do
        expect { subject }
          .not_to change { iguatemi_orders.map(&:reload).pluck(:batch_id) }
          .from([nil] * iguatemi_orders.size)
      end
    end
  end

  context "failure" do
    context "passing nil as purchase channel argument" do
      subject { described_class.new(nil).call }

      include_examples "failure", ActiveModel::ValidationError

      context "correct error message" do
        subject { described_class.new(nil) }

        before { subject.call }

        it { expect(subject.all_errors).to eq("Purchase channel can't be blank") }
      end
    end

    context "passing purchase channel without orders" do
      subject { described_class.new("Purchase channel without orders").call }

      include_examples "failure", ActiveModel::ValidationError

      context "correct error message" do
        subject { described_class.new("Purchase channel without orders") }

        before { subject.call }

        it { expect(subject.all_errors).to eq("The specified purchase channel has no orders.") }
      end
    end
  end
end
