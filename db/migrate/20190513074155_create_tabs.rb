class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.string :tname
      t.integer :tsort

      t.timestamps null: false
    end
  end
end
