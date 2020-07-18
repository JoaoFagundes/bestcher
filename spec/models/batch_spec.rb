require "rails_helper"

describe Batch, type: :model do
  describe "validations" do
    subject { create :batch }

    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:reference).ignoring_case_sensitivity }
    it { should validate_presence_of(:purchase_channel) }
  end
end
