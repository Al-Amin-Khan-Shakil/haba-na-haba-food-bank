class CreateCounties < ActiveRecord::Migration[7.1]
  def change
    create_table :counties do |t|
      t.string :name
      t.references :district, null: false, foreign_key: true

      t.timestamps
    end
  end
end
