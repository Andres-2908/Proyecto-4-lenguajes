# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_01_01_000003) do
  create_table "grupos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_grupos_on_nombre", unique: true
  end

  create_table "partidos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "etapa", default: 0, null: false
    t.integer "ganador_id"
    t.integer "goles_local"
    t.integer "goles_visitante"
    t.integer "grupo_id"
    t.integer "local_id", null: false
    t.integer "penales_goles_local"
    t.integer "penales_goles_visitante"
    t.integer "ronda"
    t.datetime "updated_at", null: false
    t.integer "visitante_id", null: false
    t.index ["etapa"], name: "index_partidos_on_etapa"
    t.index ["ganador_id"], name: "index_partidos_on_ganador_id"
    t.index ["grupo_id"], name: "index_partidos_on_grupo_id"
    t.index ["local_id"], name: "index_partidos_on_local_id"
    t.index ["visitante_id"], name: "index_partidos_on_visitante_id"
  end

  create_table "selecciones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "diferencia_goles", default: 0
    t.integer "empatados", default: 0
    t.integer "ganados", default: 0
    t.integer "goles_a_favor", default: 0
    t.integer "goles_en_contra", default: 0
    t.integer "grupo_id", null: false
    t.integer "jugados", default: 0
    t.string "nombre", null: false
    t.integer "perdidos", default: 0
    t.integer "puntos", default: 0
    t.datetime "updated_at", null: false
    t.index ["grupo_id"], name: "index_selecciones_on_grupo_id"
    t.index ["nombre"], name: "index_selecciones_on_nombre", unique: true
  end

  add_foreign_key "partidos", "grupos"
  add_foreign_key "partidos", "selecciones", column: "ganador_id"
  add_foreign_key "partidos", "selecciones", column: "local_id"
  add_foreign_key "partidos", "selecciones", column: "visitante_id"
  add_foreign_key "selecciones", "grupos"
end
