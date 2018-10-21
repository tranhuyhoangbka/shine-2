class CreateCustomersBillingAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :customers_billing_addresses do |t|
      t.references :customer, foreign_key: true
      t.references :address, foreign_key: true

      t.timestamps
    end
  end
end
