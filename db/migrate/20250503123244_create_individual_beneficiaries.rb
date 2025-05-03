class CreateIndividualBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :individual_beneficiaries, id: :uuid do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :phone_number
      t.string :case_name
      t.string :case_description
      t.string :father_name
      t.string :mother_name
      t.string :sur_name
      t.decimal :provided_food
      t.string :village
      t.string :parish
      t.string :address_note
      t.references :district, null: false, foreign_key: true, type: :uuid
      t.references :county, null: false, foreign_key: true, type: :uuid
      t.references :sub_county, null: false, foreign_key: true, type: :uuid
      t.references :request, null: true, foreign_key: true, type: :uuid
      t.references :branch, null: true, foreign_key: true, type: :uuid
      t.references :event, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
