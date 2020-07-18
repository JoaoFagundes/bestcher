require "rails_helper"

describe Order, type: :model do
  describe "validations" do
    subject { create :order }

    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:reference).ignoring_case_sensitivity }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:delivery_service) }
    it { should validate_presence_of(:total_value) }
    it { should validate_numericality_of(:total_value).is_greater_than(0) }
    it { should define_enum_for(:status).with_values(%i[ready production closing sent]) }

    context "batch_id" do
      let(:order) { create :order }

      context "status ready" do
        context "without batch" do
          it "is valid" do
            expect(order).to be_valid
          end
        end

        context "with batch" do
          let(:batch) { create :batch }

          it "is not valid" do
            order.update_attribute(:batch_id, batch.id)

            expect(order).to be_invalid
          end
        end
      end

      context "status !ready" do
        let(:batch) { create :batch }

        before { order.update_attribute(:status, :closing) }

        context "without batch" do
          it "is not valid" do
            expect(order).to be_invalid
          end
        end

        context "with batch" do
          before { order.update_attribute(:batch_id, batch.id) }

          it "is valid" do
            expect(order).to be_valid
          end
        end
      end
    end
  end
end
