class CreateDonations < ActiveRecord::Migration[7.1]
  def change
    create_table :donations, id: :uuid do |t|
      t.string :donor_name
      t.string :phone_number
      t.integer :donation_type
      t.string :donation_name
      t.integer :amount
      t.references :request, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
