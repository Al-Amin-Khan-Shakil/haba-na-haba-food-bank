class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests, id: :uuid do |t|
      t.string :name
      t.string :phone_number
      t.integer :request_type
      t.boolean :is_selected
      t.string :village
      t.string :parish
      t.string :address_note
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.references :district, null: false, foreign_key: true, type: :uuid
      t.references :county, null: true, foreign_key: true, type: :uuid
      t.references :sub_county, null: true, foreign_key: true, type: :uuid
      t.references :user, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
