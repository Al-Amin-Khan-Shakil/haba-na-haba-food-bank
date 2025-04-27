class CreateSubCounties < ActiveRecord::Migration[7.1]
  def change
    create_table :sub_counties, id: :uuid do |t|
      t.string :name
      t.references :county, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
