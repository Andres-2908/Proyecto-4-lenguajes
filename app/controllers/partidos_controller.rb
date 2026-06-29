class PartidosController < ApplicationController
  before_action :set_partido, only: %i[edit update]

  def index
    @partidos_por_etapa = Partido.includes(:local, :visitante, :grupo)
                                 .order(:etapa, :numero, :id)
                                 .group_by(&:etapa)
  end

  def edit
  end

  def update
    if @partido.update(partido_params)
      if @partido.fase_grupos?
        CalculadorPosicionesGrupo.calcular(@partido.grupo) if @partido.grupo
      else
        AvanzadorRonda.avanzar(@partido)
      end
      redirect_to partidos_path, notice: 'resultado guardado'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_partido
    @partido = Partido.find(params[:id])
  end

  def partido_params
    params.require(:partido).permit(:goles_local, :goles_visitante,
                                    :penales_goles_local, :penales_goles_visitante)
  end
end
