class RenameZipcdeFromAddresses < ActiveRecord::Migration[5.1]
  def change
    rename_column :addresses, :zipcde, :zipcode
  end
end
