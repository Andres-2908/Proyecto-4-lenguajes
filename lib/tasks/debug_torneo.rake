namespace :torneo do
  desc "Debug: muestra estado del torneo"
  task debug: :environment do
    puts "=" * 50
    puts "ESTADO DEL TORNEO"
    puts "=" * 50
    puts "Grupos: #{Grupo.count}"
    puts "Selecciones: #{Seleccion.count}"
    puts "Partidos totales: #{Partido.count}"
    puts ""

    puts "-- Fase grupos --"
    Partido.fase_grupos.group(:grupo_id).count.each do |gid, count|
      g = Grupo.find(gid)
      jugados = Partido.fase_grupos.where(grupo_id: gid).select(&:jugado?).size
      puts "  Grupo #{g.nombre}: #{count} partidos, #{jugados} jugados"
    end
    puts "  Completa: #{GeneradorCuadro.fase_grupos_completa?}"
    puts ""

    puts "-- Eliminatorias --"
    %i[dieciseisavos octavos cuartos semifinal tercer_lugar final].each do |etapa|
      ps = Partido.where(etapa: etapa)
      next if ps.empty?
      jugados = ps.select(&:jugado?).size
      puts "  #{etapa}: #{ps.count} partidos, #{jugados} jugados"
      ps.each do |p|
        g = p.jugado? ? "#{p.goles_local}-#{p.goles_visitante}" : "pendiente"
        pen = p.penales_goles_local ? " (#{p.penales_goles_local}-#{p.penales_goles_visitante} pen)" : ""
        w = p.ganador&.nombre || "-"
        puts "    ##{p.numero}: #{p.local.nombre} vs #{p.visitante.nombre} (#{g}#{pen}) ganador: #{w}"
      end
    end
    puts ""

    final = Partido.find_by(etapa: :final)
    tercer = Partido.find_by(etapa: :tercer_lugar)
    if final&.ganador
      sub = final.ganador_id == final.local_id ? final.visitante : final.local
      puts "CAMPEON: #{final.ganador.nombre}"
      puts "SUBCAMPEON: #{sub.nombre}"
    end
    if tercer&.ganador
      puts "TERCER LUGAR: #{tercer.ganador.nombre}"
    end
    puts "=" * 50
  end
end
