class GeneradorCuadro
  def self.generar
    return false unless fase_grupos_completa?
    return false if Partido.where.not(etapa: :fase_grupos).exists?

    CalculadorPosicionesGrupo.calcular_todos
    clasificacion = ServicioClasificacion.clasificados

    primeros = indexar_por_grupo(clasificacion.primeros)
    segundos = indexar_por_grupo(clasificacion.segundos)
    terceros = indexar_por_grupo(clasificacion.terceros)
    grupos_terceros = terceros.keys

    ActiveRecord::Base.transaction do
      CuadroFifa2026::DIECISEISAVOS.each do |numero, plantilla|
        local = resolver(plantilla[:local], primeros, segundos, terceros, grupos_terceros)
        visitante = resolver(plantilla[:visitante], primeros, segundos, terceros, grupos_terceros)
        Partido.create!(numero: numero, etapa: :dieciseisavos, local: local, visitante: visitante)
      end
    end
    true
  end

  def self.fase_grupos_completa?
    partidos = Partido.where(etapa: :fase_grupos)
    partidos.exists? && partidos.all?(&:jugado?)
  end

  def self.indexar_por_grupo(selecciones)
    selecciones.compact.index_by { |seleccion| seleccion.grupo.nombre }
  end

  def self.resolver(spec, primeros, segundos, terceros, grupos_terceros)
    case spec[0]
    when :pos
      spec[1] == 1 ? primeros.fetch(spec[2]) : segundos.fetch(spec[2])
    when :tercero
      grupo = CuadroFifa2026.tercero_para(spec[1], grupos_terceros)
      terceros.fetch(grupo)
    end
  end
end
