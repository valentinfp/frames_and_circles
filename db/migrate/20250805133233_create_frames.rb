class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.float :height
      t.float :width
      t.float :x
      t.float :y

      t.timestamps
    end
  end
end
