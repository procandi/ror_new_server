class AddUphoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uphone, :string
  end
end
