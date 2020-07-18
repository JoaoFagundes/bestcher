FactoryBot.define do
  factory :batch do
    reference { rand(99999999).to_s }
    purchase_channel { "Site BR" }

    trait :with_orders do
      after(:create) do |batch|
        create_list :order, 3, status: :production, batch: batch
      end
    end
  end
end
