class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :api_key, null: false
      t.integer :treatment_interval_days, null: false

      t.timestamps
    end
  end
end
