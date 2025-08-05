class CreateCircles < ActiveRecord::Migration[8.0]
  def change
    create_table :circles do |t|
      t.float :diameter
      t.float :x
      t.float :y
      t.references :frame, null: false, foreign_key: true

      t.timestamps
    end
  end
end
