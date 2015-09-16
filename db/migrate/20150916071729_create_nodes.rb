class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string   :value
      t.string   :ancestry
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
