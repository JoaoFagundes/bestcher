require "rails_helper"

describe Orders::Creator do
  subject { described_class.new(params).call }
  let(:params) { attributes_for(:order) }

  shared_examples "success" do
    it { is_expected.to be_truthy }

    it { expect { subject }.to change { Order.count }.by(1) }

    describe "correct params" do
      before { subject }

      it { expect(Order.last).to have_attributes(params) }
    end
  end

  shared_examples "failure" do |error_message|
    it { is_expected.to be_falsy }

    it { expect { subject }.not_to change { Order.count } }

    context "unsafe method raises error" do
      subject { described_class.new(params).call! }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context "return error message" do
      subject { described_class.new(params) }

      before { subject.call }

      it { expect(subject.errors.full_messages.to_sentence).to eq(error_message) }
    end
  end

  context "success" do
    context "with every params" do
      include_examples "success"
    end

    context "status is not ready but there's a batch" do
      let(:batch) { create :batch }

      before { params.merge!(status: "closing", batch: batch) }

      include_examples "success"
    end
  end

  context "failure" do
    context "missing params" do
      describe "without purchase channel" do
        before { params.delete(:purchase_channel) }

        include_examples "failure", "Purchase channel can't be blank"
      end

      describe "without batch when status is not ready" do
        before { params.merge!(status: :closing) }

        include_examples "failure", "Batch can't be blank"
      end
    end
  end
end
