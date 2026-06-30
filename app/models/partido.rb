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
  validates :goles_local, :goles_visitante,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
  validates :penales_goles_local, :penales_goles_visitante,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
  validate :equipos_diferentes
  validate :resultado_completo
  validate :equipos_del_grupo_en_fase_grupos
  validate :partido_de_grupo_no_duplicado

  def jugado?
    goles_local.present? && goles_visitante.present?
  end

  def pendiente?
    !jugado?
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

    if fase_grupos?
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

  private

  def equipos_diferentes
    return if local_id.blank? || visitante_id.blank?

    errors.add(:visitante_id, 'debe ser una selección diferente a la local') if local_id == visitante_id
  end

  def resultado_completo
    return if goles_local.blank? && goles_visitante.blank?
    return if goles_local.present? && goles_visitante.present?

    errors.add(:base, 'Debe registrar los goles de ambas selecciones')
  end

  def equipos_del_grupo_en_fase_grupos
    return unless fase_grupos?
    return if grupo.blank? || local.blank? || visitante.blank?

    if local.grupo_id != grupo_id || visitante.grupo_id != grupo_id
      errors.add(:base, 'Las selecciones deben pertenecer al grupo del partido')
    end
  end

  def partido_de_grupo_no_duplicado
    return unless fase_grupos?
    return if grupo_id.blank? || local_id.blank? || visitante_id.blank?

    duplicado = Partido.where(grupo_id: grupo_id, etapa: :fase_grupos)
                       .where(
                         '(local_id = :local_id AND visitante_id = :visitante_id) OR ' \
                         '(local_id = :visitante_id AND visitante_id = :local_id)',
                         local_id: local_id,
                         visitante_id: visitante_id
                       )
    duplicado = duplicado.where.not(id: id) if persisted?

    errors.add(:base, 'Este partido de fase de grupos ya existe') if duplicado.exists?
  end
end
