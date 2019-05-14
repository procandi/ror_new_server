class AddTabToNews < ActiveRecord::Migration
  def change
    add_column :news, :tab, :string
  end
end
