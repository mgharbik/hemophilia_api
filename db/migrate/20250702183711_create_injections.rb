class CreateInjections < ActiveRecord::Migration[8.0]
  def change
    create_table :injections do |t|
      t.references :patient, null: false, foreign_key: true
      t.float :dose, null: false
      t.string :lot_number, null: false
      t.string :drug_name, null: false
      t.datetime :injected_at, null: false

      t.timestamps
    end
  end
end
