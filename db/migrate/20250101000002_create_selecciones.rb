class CreateSelecciones < ActiveRecord::Migration[8.0]
  def change
    create_table :selecciones do |t|
      t.string :nombre, null: false
      t.references :grupo, null: false, foreign_key: true
      t.integer :puntos, default: 0
      t.integer :goles_a_favor, default: 0
      t.integer :goles_en_contra, default: 0
      t.integer :diferencia_goles, default: 0
      t.integer :jugados, default: 0
      t.integer :ganados, default: 0
      t.integer :empatados, default: 0
      t.integer :perdidos, default: 0
      t.timestamps
    end
    add_index :selecciones, :nombre, unique: true
  end
end
