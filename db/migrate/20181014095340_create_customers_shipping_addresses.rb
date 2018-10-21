class CreateCustomersShippingAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :customers_shipping_addresses do |t|
      t.references :customer, foreign_key: true
      t.references :address, foreign_key: true
      t.boolean :primary, null: false, default: false

      t.timestamps
    end
  end
end
