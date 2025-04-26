class CreateSubCounties < ActiveRecord::Migration[7.1]
  def change
    create_table :sub_counties do |t|
      t.string :name
      t.references :county, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true

      t.timestamps
    end
  end
end
