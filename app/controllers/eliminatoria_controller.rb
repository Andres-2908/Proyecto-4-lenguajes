class EliminatoriaController < ApplicationController
  ORDEN_ETAPAS = %w[dieciseisavos octavos cuartos semifinal tercer_lugar final].freeze

  def show
    @cuadro_generado = Partido.where.not(etapa: :fase_grupos).exists?
    @fase_grupos_completa = GeneradorCuadro.fase_grupos_completa?
    @rondas = Partido.where.not(etapa: :fase_grupos)
                     .includes(:local, :visitante, :ganador)
                     .order(:numero)
                     .group_by(&:etapa)
                     .sort_by { |etapa, _| ORDEN_ETAPAS.index(etapa) }
  end

  def generar
    if GeneradorCuadro.generar
      redirect_to eliminatoria_path, notice: 'cuadro generado'
    else
      redirect_to eliminatoria_path, alert: 'aun no se puede generar el cuadro'
    end
  end

  def podio
    @final = Partido.find_by(numero: 104)
    @tercer = Partido.find_by(numero: 103)
    if @final&.ganador
      @campeon = @final.ganador
      @subcampeon = @final.local_id == @final.ganador_id ? @final.visitante : @final.local
    end
    @tercer_lugar = @tercer&.ganador
  end
end
