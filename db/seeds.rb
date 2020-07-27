# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Order.create!(reference: 'BR102030',
              purchase_channel: 'Site BR',
              client: 'São Clênio',
              address: 'Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250',
              delivery_service: 'SEDEX',
              total_value: 123.30,
              line_items: [
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
              ],
              status: :ready)

Order.create!(reference: 'BR405060',
              purchase_channel: 'Site BR',
              client: 'São Clênio',
              address: 'Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250',
              delivery_service: 'PAC',
              total_value: 341.20,
              line_items: [
                {
                  'sku' => 'case-my-best-friend',
                  'model' => 'iPhone X',
                  'case type' => 'Rose Leather'
                },
                {
                  'sku' => 'case-my-best-friend',
                  'model' => 'iPhone X',
                  'case type' => 'Blue Velvet'
                },
                {
                  'sku' => 'powebank-sunshine',
                  'capacity' => '20000mah'
                },
                {
                  'sku' => 'earphone-standard',
                  'color' => 'green'
                },
                {
                  'sku' => 'earphone-standard',
                  'color' => 'blue'
                },
                {
                  'sku' => 'earphone-standard',
                  'color' => 'red'
                }
              ],
              status: :ready)

Order.create!(reference: 'BR112131',
              purchase_channel: 'Iguatemi Store',
              client: 'Luke Skywalker',
              address: 'Rua dos Bobos, nº 0',
              delivery_service: 'PAC',
              total_value: 100.0,
              line_items: [
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
              ],
              status: :ready)

FactoryBot.create(:batch, :with_orders)
FactoryBot.create(:batch, :with_orders, purchase_channel: "Iguatemi Store")
batch = FactoryBot.create(:batch, :with_orders, purchase_channel: "Site BR")
orders = FactoryBot.create_list(:order, 5, status: :production, purchase_channel: "Site BR", batch: batch)
