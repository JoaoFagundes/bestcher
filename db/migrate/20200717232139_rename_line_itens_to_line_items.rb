class RenameLineItensToLineItems < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :line_itens, :line_items
  end
end
