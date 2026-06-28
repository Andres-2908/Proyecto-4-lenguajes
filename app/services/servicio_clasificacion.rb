ClasificacionResult = Struct.new(:primeros, :segundos, :terceros, keyword_init: true)

class ServicioClasificacion
  def self.clasificados
    grupos = Grupo.all.order(:nombre)
    primeros = grupos.map { |g| g.tabla_posiciones.to_a[0] }
    segundos = grupos.map { |g| g.tabla_posiciones.to_a[1] }

    terceros = grupos.map { |g| g.tabla_posiciones.to_a[2] }.compact
                     .sort_by { |t| [-t.puntos, -t.diferencia_goles, -t.goles_a_favor] }
                     .first(8)

    ClasificacionResult.new(primeros: primeros, segundos: segundos, terceros: terceros)
  end
end
