class Partido < ApplicationRecord
  belongs_to :grupo, optional: true
  belongs_to :local, class_name: 'Seleccion'
  belongs_to :visitante, class_name: 'Seleccion'
  belongs_to :ganador, class_name: 'Seleccion', optional: true

  enum :etapa, {
    fase_grupos: 0,
    dieciseisavos: 1,
    octavos: 2,
    cuartos: 3,
    semifinal: 4,
    tercer_lugar: 5,
    final: 6
  }

  validates :local_id, :visitante_id, :etapa, presence: true

  def jugado?
    goles_local.present? && goles_visitante.present?
  end

  def empate?
    jugado? && goles_local == goles_visitante
  end

  def resultado_vs(equipo)
    return nil unless jugado?
    if local_id == equipo.id
      if goles_local > goles_visitante then :ganado
      elsif goles_local < goles_visitante then :perdido
      else :empatado
      end
    else
      if goles_visitante > goles_local then :ganado
      elsif goles_visitante < goles_local then :perdido
      else :empatado
      end
    end
  end

  def goles_para(equipo)
    return nil unless jugado?
    equipo.id == local_id ? goles_local : goles_visitante
  end

  def goles_contra(equipo)
    return nil unless jugado?
    equipo.id == local_id ? goles_visitante : goles_local
  end

  def determinar_ganador!
    return nil unless jugado?

    if etapa == 'fase_grupos'
      update(ganador_id: nil)
      return nil
    end

    if goles_local != goles_visitante
      winner = goles_local > goles_visitante ? local : visitante
    elsif penales_goles_local.present?
      winner = penales_goles_local > penales_goles_visitante ? local : visitante
    else
      winner = nil
    end

    update(ganador_id: winner&.id)
    winner
  end

end
