class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.references :district, null: true, foreign_key: true, type: :uuid
      t.references :county, null: true, foreign_key: true, type: :uuid
      t.references :sub_county, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
