class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :upw
      t.string :uname
      t.string :utitle

      t.timestamps null: false
    end
  end
end
