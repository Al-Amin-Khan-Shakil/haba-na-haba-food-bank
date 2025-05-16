class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories, id: :uuid do |t|
      t.string :name
      t.date :expire_date
      t.decimal :amount
      t.decimal :cost_of_item
      t.string :collection_place
      t.string :phone_number
      t.string :donor_name
      t.references :district, null: false, foreign_key: true, type: :uuid
      t.references :county, null: false, foreign_key: true, type: :uuid
      t.references :sub_county, null: false, foreign_key: true, type: :uuid
      t.references :request, null: true, foreign_key: true, type: :uuid
      t.references :branch, null: true, foreign_key: true, type: :uuid
      t.references :event, null: true, foreign_key: true, type: :uuid
      t.references :donation, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
