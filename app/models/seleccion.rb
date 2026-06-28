class Seleccion < ApplicationRecord
  belongs_to :grupo
  has_many :partidos_como_local, class_name: 'Partido', foreign_key: :local_id, dependent: :destroy
  has_many :partidos_como_visitante, class_name: 'Partido', foreign_key: :visitante_id, dependent: :destroy

  validates :nombre, presence: true, uniqueness: true

  def partidos
    Partido.where('local_id = ? OR visitante_id = ?', id, id)
  end

  def partidos_grupo
    partidos.where(etapa: :fase_grupos)
  end

  def actualizar_estadisticas!
    stats = partidos_grupo.select(&:jugado?)
    self.jugados = stats.size
    self.ganados = stats.count { |p| p.resultado_vs(self) == :ganado }
    self.empatados = stats.count { |p| p.resultado_vs(self) == :empatado }
    self.perdidos = stats.count { |p| p.resultado_vs(self) == :perdido }
    self.goles_a_favor = stats.sum { |p| p.goles_para(self) }
    self.goles_en_contra = stats.sum { |p| p.goles_contra(self) }
    self.puntos = ganados * 3 + empatados * 1
    self.diferencia_goles = goles_a_favor - goles_en_contra
    save!
  end
end
