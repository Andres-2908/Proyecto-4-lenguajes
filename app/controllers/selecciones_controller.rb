class SeleccionesController < ApplicationController
  before_action :set_seleccion, only: %i[show edit update destroy]

  def index
    @selecciones = Seleccion.includes(:grupo).order('grupos.nombre', :nombre)
  end

  def show
  end

  def new
    @seleccion = Seleccion.new
  end

  def edit
  end

  def create
    @seleccion = Seleccion.new(seleccion_params)
    if @seleccion.save
      redirect_to @seleccion, notice: 'Selección registrada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @seleccion.update(seleccion_params)
      redirect_to @seleccion, notice: 'Selección actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @seleccion.destroy!
    redirect_to selecciones_url, notice: 'Selección eliminada exitosamente.'
  end

  private

  def set_seleccion
    @seleccion = Seleccion.find(params[:id])
  end

  def seleccion_params
    params.require(:seleccion).permit(:nombre, :grupo_id)
  end
end
