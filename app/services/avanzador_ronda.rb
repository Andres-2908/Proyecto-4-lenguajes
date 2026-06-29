class AvanzadorRonda
  def self.avanzar(partido)
    return unless partido.jugado?
    partido.determinar_ganador!
    CuadroFifa2026.consumidores(partido.numero).each do |numero|
      crear_si_listo(numero)
    end
  end

  def self.crear_si_listo(numero)
    return if Partido.exists?(numero: numero)
    plantilla = CuadroFifa2026::RONDAS_SIGUIENTES.fetch(numero)
    local = resolver(plantilla[:local])
    visitante = resolver(plantilla[:visitante])
    return unless local && visitante
    Partido.create!(numero: numero, etapa: plantilla[:etapa], local: local, visitante: visitante)
  end

  def self.resolver(spec)
    tipo, numero = spec
    origen = Partido.find_by(numero: numero)
    return nil unless origen&.ganador_id
    case tipo
    when :ganador then origen.ganador
    when :perdedor then origen.local_id == origen.ganador_id ? origen.visitante : origen.local
    end
  end
end
