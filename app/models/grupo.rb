class Grupo < ApplicationRecord
  has_many :selecciones, dependent: :destroy
  has_many :partidos, -> { where(etapa: :fase_grupos) }

  validates :nombre, presence: true, uniqueness: true,
            inclusion: { in: ('A'..'L').to_a }

  def tabla_posiciones
    selecciones.order(puntos: :desc, diferencia_goles: :desc, goles_a_favor: :desc)
  end

  def primeros_dos
    tabla_posiciones.limit(2)
  end
end
