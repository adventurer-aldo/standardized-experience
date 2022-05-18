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

ActiveRecord::Schema[7.0].define(version: 2022_05_14_093759) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.integer "question_id", null: false
    t.text "attempt", array: true
    t.decimal "grade", default: "0.0", null: false
    t.integer "question_type", limit: 2, default: 0, null: false
    t.text "variables", default: [], null: false, array: true
  end

  create_table "chairs", id: :serial, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "journey_id", null: false
    t.integer "format", limit: 2, default: 0, null: false
    t.decimal "first"
    t.decimal "second"
    t.decimal "reposition"
    t.decimal "dissertation"
    t.decimal "exam"
    t.decimal "recurrence"
  end

  create_table "choices", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.text "decoy", null: false
  end

  create_table "journeys", id: :serial, force: :cascade do |t|
    t.integer "duration", limit: 2, null: false
    t.time "start_time", null: false
    t.time "end_time"
    t.integer "level", limit: 2, default: 1, null: false
    t.integer "soundtrack_id", null: false
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.text "question_types", null: false, array: true
    t.text "question", null: false
    t.text "answer", null: false, array: true
    t.text "tags", default: [], null: false, array: true
    t.integer "level", limit: 2, default: 1, null: false
    t.integer "frequency", default: [0, 0, 0], null: false, array: true
    t.text "parameters", default: [], null: false, array: true
  end

  create_table "quizzes", id: :serial, force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.integer "subject_id", null: false
    t.integer "journey_id", default: 0, null: false
    t.time "start_time", null: false
    t.time "end_time"
    t.integer "format", limit: 2, default: 0, null: false
    t.integer "level", limit: 2, default: 0, null: false
  end

  create_table "soundtracks", id: :integer, default: -> { "nextval('soundtrack_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "home"
    t.text "preparations"
    t.text "preparations_second"
    t.text "preparations_exam"
    t.text "practice", array: true
    t.text "first", array: true
    t.text "first_rush", array: true
    t.text "second", array: true
    t.text "second_rush", array: true
    t.text "dissertation", array: true
    t.text "exam", array: true
    t.text "exam_rush", array: true
    t.text "recurrence", array: true
    t.text "recurrence_rush", array: true
  end

  create_table "stats", id: :serial, force: :cascade do |t|
    t.integer "current_journey", default: 0, null: false
    t.text "username"
    t.text "password"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.text "title", null: false
    t.integer "difficulty", null: false
    t.integer "formula", limit: 2, default: 0, null: false
    t.integer "evaluable", limit: 2, default: 1, null: false
    t.index ["title"], name: "subjects_title_key", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions", name: "question"
  add_foreign_key "answers", "quizzes", name: "quiz"
  add_foreign_key "chairs", "journeys", name: "journey"
  add_foreign_key "chairs", "subjects", name: "subject"
  add_foreign_key "choices", "questions", name: "question"
  add_foreign_key "journeys", "soundtracks", name: "journeys_soundtrack_id_fkey"
  add_foreign_key "stats", "journeys", column: "current_journey", name: "journey"
end
