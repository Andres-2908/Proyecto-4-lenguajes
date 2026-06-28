class CreatePartidos < ActiveRecord::Migration[8.0]
  def change
    create_table :partidos do |t|
      t.references :grupo, foreign_key: true
      t.references :local, null: false, foreign_key: { to_table: :selecciones }
      t.references :visitante, null: false, foreign_key: { to_table: :selecciones }
      t.integer :goles_local
      t.integer :goles_visitante
      t.references :ganador, foreign_key: { to_table: :selecciones }
      t.integer :penales_goles_local
      t.integer :penales_goles_visitante
      t.integer :etapa, null: false, default: 0
      t.integer :ronda
      t.timestamps
    end
    add_index :partidos, :etapa
  end
end
