class CalculadorPosicionesGrupo
  def self.calcular(grupo)
    grupo.selecciones.each(&:actualizar_estadisticas!)
    grupo.tabla_posiciones
  end

  def self.calcular_todos
    Grupo.all.map { |g| calcular(g) }
  end
end
