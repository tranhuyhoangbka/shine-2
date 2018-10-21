class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :code, size: 2, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
