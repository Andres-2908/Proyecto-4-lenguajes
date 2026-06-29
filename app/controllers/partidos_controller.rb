class PartidosController < ApplicationController
  before_action :set_partido, only: %i[edit update]

  def index
    @grupos = Grupo.order(:nombre)
    @grupo = Grupo.find_by(id: params[:grupo_id]) || @grupos.first
    @partidos_fase_grupos = Partido.includes(:grupo, :local, :visitante)
                                   .fase_grupos
                                   .order(:grupo_id, :id)
    @partidos_fase_grupos = @partidos_fase_grupos.where(grupo: @grupo) if @grupo.present?
    @partidos_eliminatoria = Partido.includes(:local, :visitante)
                                    .where.not(etapa: :fase_grupos)
                                    .order(:etapa, :numero, :id)
                                    .group_by(&:etapa)
  end

  def edit
    if @partido.fase_grupos? && @partido.jugado?
      redirect_to partidos_path(grupo_id: @partido.grupo_id), alert: 'Este partido de fase de grupos ya tiene resultado registrado.'
    end
  end

  def update
    if @partido.fase_grupos? && @partido.jugado?
      redirect_to partidos_path(grupo_id: @partido.grupo_id), alert: 'Este partido de fase de grupos ya tiene resultado registrado.'
      return
    end

    if @partido.update(partido_params)
      if @partido.fase_grupos?
        CalculadorPosicionesGrupo.calcular(@partido.grupo) if @partido.grupo
        destino = grupo_path(@partido.grupo)
      else
        AvanzadorRonda.avanzar(@partido)
        destino = partidos_path
      end

      redirect_to destino, notice: 'Resultado guardado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def generar_fase_grupos
    creados = GeneradorPartidosFaseGrupos.call
    mensaje = if creados.positive?
                "Se generaron #{creados} partidos de fase de grupos."
              else
                'La fase de grupos ya estaba generada.'
              end

    redirect_to partidos_path, notice: mensaje
  rescue ActiveRecord::RecordInvalid => e
    redirect_to partidos_path, alert: "No se pudieron generar los partidos: #{e.record.errors.full_messages.to_sentence}"
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
