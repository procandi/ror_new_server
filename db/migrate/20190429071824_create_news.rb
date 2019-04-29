class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.date :postdate
      t.time :posttime
      t.string :title
      t.string :body
      t.string :picture

      t.timestamps null: false
    end
  end
end
