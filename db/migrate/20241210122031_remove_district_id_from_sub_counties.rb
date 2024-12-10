class RemoveDistrictIdFromSubCounties < ActiveRecord::Migration[7.1]
  def change
    remove_column :sub_counties, :district_id, :bigint
  end
end
