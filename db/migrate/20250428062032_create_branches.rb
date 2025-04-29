class CreateBranches < ActiveRecord::Migration[7.1]
  def change
    create_table :branches, id: :uuid do |t|
      t.string :name
      t.string :phone_number
      t.string :address

      t.timestamps
    end
  end
end
