FactoryBot.define do
  factory :order do
    reference { rand(99999999).to_s }
    purchase_channel { "Site BR" }
    address { "Rua dos Bobos nº 0" }
    client { "São Clênio" }
    delivery_service { rand(99).even? ? "SEDEX" : "PAC" }
    total_value { (rand(49999) / 100.0).to_d }
    line_items do
      [
        {
         'sku' => 'case-my-best-friend',
         'model' => 'iPhone X',
         'case type' => 'Rose Leather'
        },
        {
          'sku' => 'powebank-sunshine',
          'capacity' => '10000mah'
        },
        {
          'sku' => 'earphone-standard',
          'color' => 'white'
        }
      ]
    end

    status { "ready" }
  end
end
