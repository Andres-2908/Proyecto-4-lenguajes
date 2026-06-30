namespace :torneo do
  desc "Asigna resultados aleatorios a la fase de grupos"
  task simular_grupos: :environment do
    Partido.fase_grupos.each do |p|
      goles_local = rand(0..4)
      goles_visitante = rand(0..4)
      p.update!(goles_local: goles_local, goles_visitante: goles_visitante)
    end
    CalculadorPosicionesGrupo.calcular_todos
    puts "72 partidos de fase grupos simulados."
  end

  desc "Genera cuadro de eliminatorias"
  task generar_eliminatorias: :environment do
    if GeneradorCuadro.generar
      puts "Cuadro de dieciseisavos generado."
    else
      puts "No se pudo generar el cuadro."
    end
  end

  def self.asignar_resultado_con_penales(partido, gl, gv)
    attrs = { goles_local: gl, goles_visitante: gv, ganador_id: nil }
    if gl == gv
      pen_local = rand(3..5)
      pen_vis = rand(3..5)
      pen_vis = pen_local == 5 ? 3 : pen_local + 1 if pen_local == pen_vis
      attrs.merge!(penales_goles_local: pen_local, penales_goles_visitante: pen_vis)
    else
      attrs.merge!(penales_goles_local: nil, penales_goles_visitante: nil)
    end
    partido.update!(attrs)
  end

  desc "Simula todas las rondas eliminatorias hasta el campeón"
  task simular_eliminatorias: :environment do
    etapas = %i[dieciseisavos octavos cuartos semifinal]
    etapas.each do |etapa|
      Partido.where(etapa: etapa).each do |p|
        if rand(0..2) == 0 && etapa != :semifinal
          asignar_resultado_con_penales(p, rand(0..2), rand(0..2))
        else
          asignar_resultado_con_penales(p, rand(0..4), rand(0..3))
        end
        AvanzadorRonda.avanzar(p)
      end
    end

    final = Partido.find_by(etapa: :final)
    tercer = Partido.find_by(etapa: :tercer_lugar)

    if final
      asignar_resultado_con_penales(final, rand(1..3), rand(0..2))
      AvanzadorRonda.avanzar(final)
    end
    if tercer
      asignar_resultado_con_penales(tercer, rand(1..3), rand(0..2))
      AvanzadorRonda.avanzar(tercer)
    end

    puts "Eliminatorias simuladas."
    c = final&.ganador
    s = c == final&.local ? final&.visitante : final&.local
    t = tercer&.ganador
    puts "Campeón: #{c&.nombre} | Subcampeón: #{s&.nombre} | Tercero: #{t&.nombre}"
  end

  desc "Ejecuta simulacion completa (grupos + eliminatorias)"
  task simular_completo: [:simular_grupos, :generar_eliminatorias, :simular_eliminatorias]
end
