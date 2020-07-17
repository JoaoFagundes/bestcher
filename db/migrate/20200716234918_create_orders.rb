class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :reference, null: false
      t.string :purchase_channel,  null: false
      t.string :client
      t.string :address
      t.string :delivery_service
      t.decimal :total_value
      t.jsonb :line_itens
      t.integer :status
      t.references :batch

      t.timestamps
    end
  end
end
