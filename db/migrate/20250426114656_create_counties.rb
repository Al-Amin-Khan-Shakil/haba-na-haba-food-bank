class CreateCounties < ActiveRecord::Migration[7.1]
  def change
    create_table :counties, id: :uuid do |t|
      t.string :name
      t.references :district, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
