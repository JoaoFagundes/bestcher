require "rails_helper"

describe Batch, type: :model do
  describe "validations" do
    subject { create :batch, purchase_channel: "Site BR" }

    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:reference).ignoring_case_sensitivity }
    it { should validate_presence_of(:purchase_channel) }

    context "orders' purchase channel" do
      let!(:site_br_orders) { create_list :order, 3, purchase_channel: "Site BR" }
      let!(:iguatemi_orders) { create_list :order, 3, purchase_channel: "Iguatemi Store" }

      context "batch with orders from multiple purchase channels" do
        before do
          site_br_orders.each { |order| order.update_attribute(:batch, subject) }
          iguatemi_orders.each { |order| order.update_attribute(:batch, subject) }
        end

        it "batch is invalid" do
          expect(subject.reload).to be_invalid
        end

        context "fixing incorrect orders" do
          context "removing iguatemi orders" do
            before { iguatemi_orders.each { |order| order.update_attribute(:batch, nil) } }

            it "batch is valid" do
              expect(subject.reload).to be_valid
            end
          end
        end
      end

      context "batch with orders from single purchase channels" do
        before do
          site_br_orders.each { |order| order.update_attribute(:batch, subject) }
        end

        it "batch is valid" do
          expect(subject.reload).to be_valid
        end

        context "inserting incorrect orders" do
          context "inserting iguatemi orders" do
            before { iguatemi_orders.each { |order| order.update_attribute(:batch, subject) } }

            it "batch is valid" do
              expect(subject.reload).to be_invalid
            end
          end
        end
      end
    end
  end
end
