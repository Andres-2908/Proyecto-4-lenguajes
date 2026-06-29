require "test_helper"

class PartidosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grupo = Grupo.create!(nombre: "C")
    @local = Seleccion.create!(nombre: "Local Controller", grupo: @grupo)
    @visitante = Seleccion.create!(nombre: "Visitante Controller", grupo: @grupo)
    @partido = Partido.create!(grupo: @grupo, local: @local, visitante: @visitante, etapa: :fase_grupos)
  end

  test "muestra partidos de fase de grupos" do
    get partidos_url(grupo_id: @grupo.id)

    assert_response :success
    assert_includes response.body, @local.nombre
    assert_includes response.body, @visitante.nombre
  end

  test "registra resultado y actualiza tabla" do
    patch partido_url(@partido), params: {
      partido: {
        goles_local: 3,
        goles_visitante: 1
      }
    }

    assert_redirected_to grupo_url(@grupo)
    assert_equal 3, @local.reload.puntos
    assert_equal 3, @local.goles_a_favor
    assert_equal 1, @visitante.reload.goles_a_favor
  end

  test "no permite registrar dos veces un partido de fase de grupos" do
    @partido.update!(goles_local: 1, goles_visitante: 1)

    patch partido_url(@partido), params: {
      partido: {
        goles_local: 4,
        goles_visitante: 0
      }
    }

    assert_redirected_to partidos_url(grupo_id: @grupo.id)
    assert_equal 1, @partido.reload.goles_local
    assert_equal 1, @partido.goles_visitante
  end
end
