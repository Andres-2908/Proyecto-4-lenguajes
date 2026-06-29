class AddNumeroToPartidos < ActiveRecord::Migration[8.0]
  def change
    add_column :partidos, :numero, :integer
    add_index :partidos, :numero, unique: true
  end
end
