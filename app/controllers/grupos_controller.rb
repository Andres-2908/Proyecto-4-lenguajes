class GruposController < ApplicationController
  before_action :set_grupo, only: %i[show edit update destroy]

  def index
    @grupos = Grupo.all.order(:nombre)
  end

  def show
    @selecciones = @grupo.tabla_posiciones
    @partidos = @grupo.partidos.includes(:local, :visitante).order(:id)
  end

  def new
    @grupo = Grupo.new
  end

  def edit
  end

  def create
    @grupo = Grupo.new(grupo_params)
    if @grupo.save
      redirect_to @grupo, notice: 'Grupo creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @grupo.update(grupo_params)
      redirect_to @grupo, notice: 'Grupo actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @grupo.destroy!
    redirect_to grupos_url, notice: 'Grupo eliminado exitosamente.'
  end

  private

  def set_grupo
    @grupo = Grupo.find(params[:id])
  end

  def grupo_params
    params.require(:grupo).permit(:nombre)
  end
end
