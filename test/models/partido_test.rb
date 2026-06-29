require "test_helper"

class PartidoTest < ActiveSupport::TestCase
  test "rechaza goles negativos" do
    grupo = Grupo.create!(nombre: "A")
    local = Seleccion.create!(nombre: "Local Test", grupo: grupo)
    visitante = Seleccion.create!(nombre: "Visitante Test", grupo: grupo)

    partido = Partido.new(
      grupo: grupo,
      local: local,
      visitante: visitante,
      etapa: :fase_grupos,
      goles_local: -1,
      goles_visitante: 0
    )

    assert_not partido.valid?
  end

  test "rechaza partidos duplicados en fase de grupos" do
    grupo = Grupo.create!(nombre: "B")
    local = Seleccion.create!(nombre: "Local Duplicado", grupo: grupo)
    visitante = Seleccion.create!(nombre: "Visitante Duplicado", grupo: grupo)

    Partido.create!(grupo: grupo, local: local, visitante: visitante, etapa: :fase_grupos)
    duplicado = Partido.new(grupo: grupo, local: visitante, visitante: local, etapa: :fase_grupos)

    assert_not duplicado.valid?
  end
end
