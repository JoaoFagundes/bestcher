require "rails_helper"

describe Batches::StatusUpdater do
  let!(:batch) { create :batch, :with_orders }

  shared_examples "failure" do
    it { expect(subject.call).to be_falsy }

    it "doesn't update orders" do
      expect { subject.call }.not_to change { batch.orders.reload }
    end

    it "correct error message" do
      subject.call

      expect(subject.errors.full_messages).to match_array(error[:message])
    end

    it "raises error" do
      expect { subject.call! }.to raise_error(error[:type])
    end
  end

  shared_examples "success" do
    it { expect(subject.call).to be_truthy }

    it "update orders" do
      expect { subject.call }
        .to change { batch.orders.reload.pluck(:status) }
    end

    it "doesn't raises error" do
      expect { subject.call! }.not_to raise_error
    end
  end

  context "from ready" do
    before { batch.orders.each { |order| order.update_attribute(:status, :ready) } }

    context "to production" do
      subject { described_class.new(batch, :production) }

      include_examples "success"
    end

    context "to closing" do
      subject { described_class.new(batch, :closing) }

      include_examples "failure"  do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from ready to closing."] } }
      end
    end

    context "to sent" do
      subject { described_class.new(batch, :sent, delivery_service: delivery_service) }

      context "without delivery service" do
        let(:delivery_service) { "" }

        include_examples "failure" do
          let(:error) do
            {
              type: ActiveModel::ValidationError,
              message: ["Can't change status from ready to sent.", "Delivery service can't be blank"]
            }
          end
        end
      end

      context "with delivery service" do
        let(:delivery_service) { batch.orders.sample.delivery_service }

        include_examples "failure" do
          let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from ready to sent."] } }
        end
      end
    end
  end

  context "from production" do
    context "to ready" do
      subject { described_class.new(batch, :ready) }

      include_examples "failure" do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from production to ready."] } }
      end
    end

    context "to closing" do
      subject { described_class.new(batch, :closing) }

      include_examples "success"
    end

    context "to sent" do
      subject { described_class.new(batch, :sent, delivery_service: delivery_service) }

      context "without delivery service" do
        let(:delivery_service) { "" }

        include_examples "failure" do
          let(:error) do
            {
              type: ActiveModel::ValidationError,
              message: ["Can't change status from production to sent.", "Delivery service can't be blank"]
            }
          end
        end
      end

      context "with delivery service" do
        let(:delivery_service) { batch.orders.sample.delivery_service }

        include_examples "failure" do
          let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from production to sent."] } }
        end
      end
    end
  end

  context "from closing" do
    before { batch.orders.each { |order| order.update_attribute(:status, :closing) } }

    context "to ready" do
      subject { described_class.new(batch, :ready) }

      include_examples "failure" do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from closing to ready."] } }
      end
    end

    context "to production" do
      subject { described_class.new(batch, :production) }

      include_examples "failure" do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from closing to production."] } }
      end
    end

    context "to sent" do
      subject { described_class.new(batch, :sent, delivery_service: delivery_service) }

      context "without delivery_service" do
        let(:delivery_service) { "" }

        include_examples "failure" do
          let(:error) { { type: ActiveModel::ValidationError, message: ["Delivery service can't be blank"] } }
        end
      end

      context "with delivery service" do
        let(:delivery_service) { batch.orders.sample.delivery_service }

        include_examples "success"
      end
    end
  end

  context "from sent" do
    before { batch.orders.each { |order| order.update_attribute(:status, :sent) } }

    context "to ready" do
      subject { described_class.new(batch, :ready) }

      include_examples "failure" do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from sent to ready."] } }
      end
    end

    context "to production" do
      subject { described_class.new(batch, :production) }

      include_examples "failure" do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from sent to production."] } }
      end
    end

    context "to closing" do
      subject { described_class.new(batch, :closing) }

      include_examples "failure" do
        let(:error) { { type: ActiveModel::ValidationError, message: ["Can't change status from sent to closing."] } }
      end
    end
  end
end
