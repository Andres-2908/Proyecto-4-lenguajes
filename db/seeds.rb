puts "Creando grupos..."

grupos = {}
('A'..'L').each do |letra|
  grupos[letra] = Grupo.find_or_create_by!(nombre: letra)
end

puts "Creando selecciones..."

selecciones_por_grupo = {
  'A' => %w[México Argentina Nigeria Australia],
  'B' => %w[España Países\ Bajos Senegal Irán],
  'C' => %w[Estados\ Unidos Francia Japón Túnez],
  'D' => %w[Brasil Croacia Marruecos Arabia\ Saudita],
  'E' => %w[Inglaterra Uruguay Ghana Corea\ del\ Sur],
  'F' => %w[Portugal Colombia Egipto Irak],
  'G' => %w[Alemania Suiza Camerún Qatar],
  'H' => %w[Bélgica Ecuador Argelia Nueva\ Zelanda],
  'I' => %w[Chile Italia Costa\ de\ Marfil Emiratos\ Árabes],
  'J' => %w[Canadá Turquía Malí Panamá],
  'K' => %w[Dinamarca Serbia Togo Uzbekistán],
  'L' => %w[Perú Austria Zambia Jamaica],
}

selecciones_por_grupo.each do |letra, nombres|
  grupo = grupos[letra]
  nombres.each do |nombre|
    Seleccion.find_or_create_by!(nombre: nombre) do |s|
      s.grupo = grupo
    end
  end
end

puts "Creando partidos de fase de grupos..."

GeneradorPartidosFaseGrupos.call

puts "¡Seeds completados exitosamente!"
puts "  #{Grupo.count} grupos"
puts "  #{Seleccion.count} selecciones"
puts "  #{Partido.count} partidos"
