class CreateOrganizationBeneficiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_beneficiaries, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.text :organization_name
      t.integer :male
      t.integer :female
      t.text :adult_age_range
      t.text :children_age_range
      t.references :county, null: false, foreign_key: { to_table: :counties }, type: :uuid
      t.references :sub_county, null: false, foreign_key: { to_table: :sub_counties }, type: :uuid
      t.text :residence_address
      t.text :village
      t.text :parish
      t.text :phone_number
      t.text :case_name
      t.text :case_description
      t.text :registration_no
      t.text :organization_no
      t.text :directors_name
      t.text :head_of_institution
      t.integer :number_of_meals_home
      t.text :basic_FEH
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.decimal :provided_food
      t.integer :event_id
      t.uuid :district_id
      t.uuid :branch_id
      t.uuid :request_id

      t.index [:id], name: "index_organization_beneficiaries_on_id", unique: true
    end
  end
end
