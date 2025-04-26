class CreateDistricts < ActiveRecord::Migration[7.1]
  def change
    create_table :districts, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
