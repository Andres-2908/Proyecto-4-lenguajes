module EliminatoriaHelper
  NOMBRES_ETAPA = {
    "fase_grupos" => "Fase de grupos",
    "dieciseisavos" => "Dieciseisavos",
    "octavos" => "Octavos",
    "cuartos" => "Cuartos",
    "semifinal" => "Semifinal",
    "tercer_lugar" => "Tercer lugar",
    "final" => "Final"
  }.freeze

  def nombre_etapa(etapa)
    NOMBRES_ETAPA.fetch(etapa.to_s, etapa.to_s.humanize)
  end

  def marcador(partido)
    return "—" unless partido.jugado?
    base = "#{partido.goles_local} - #{partido.goles_visitante}"
    return base unless partido.penales_goles_local
    "#{base} (#{partido.penales_goles_local} - #{partido.penales_goles_visitante})"
  end
end
