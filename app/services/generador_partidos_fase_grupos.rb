class GeneradorPartidosFaseGrupos
  def self.call
    new.call
  end

  def call
    creados = 0

    Grupo.includes(:selecciones).order(:nombre).each do |grupo|
      equipos = grupo.selecciones.order(:nombre).to_a
      next unless equipos.size == 4

      equipos.combination(2) do |local, visitante|
        next if partido_existente?(grupo, local, visitante)

        Partido.create!(
          grupo: grupo,
          etapa: :fase_grupos,
          local: local,
          visitante: visitante
        )
        creados += 1
      end
    end

    creados
  end

  private

  def partido_existente?(grupo, local, visitante)
    Partido.where(grupo: grupo, etapa: :fase_grupos)
           .where(
             '(local_id = :local_id AND visitante_id = :visitante_id) OR ' \
             '(local_id = :visitante_id AND visitante_id = :local_id)',
             local_id: local.id,
             visitante_id: visitante.id
           )
           .exists?
  end
end
