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
    t.integer "veracity", limit: 2, default: 0, null: false
  end

# Could not dump table "journeys" because of following StandardError
#   Unknown type 'time with time zone' for column 'start_time'

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.text "question_types", null: false, array: true
    t.text "question", null: false
    t.text "answer", null: false, array: true
    t.text "tags", default: [], null: false, array: true
    t.integer "level", limit: 2, default: 1, null: false
    t.integer "frequency", default: [0, 0, 0], null: false, array: true
    t.text "parameters", default: [], null: false, array: true
    t.integer "stat_id", default: 1, null: false
  end

# Could not dump table "quizzes" because of following StandardError
#   Unknown type 'time with time zone' for column 'start_time'

  create_table "soundtracks", id: :integer, default: -> { "nextval('soundtrack_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "home", null: false
    t.text "preparations", null: false
    t.text "preparations_second", null: false
    t.text "preparations_exam", null: false
    t.text "practice", array: true
    t.text "first", array: true
    t.text "first_rush", default: [""], null: false, array: true
    t.text "second", array: true
    t.text "second_rush", default: [""], null: false, array: true
    t.text "dissertation", array: true
    t.text "exam", array: true
    t.text "exam_rush", default: [""], null: false, array: true
    t.text "recurrence", array: true
    t.text "recurrence_rush", default: [""], null: false, array: true
    t.text "dissertation_rush", default: [""], null: false, array: true
    t.text "practice_rush", default: [""], null: false, array: true
    t.text "preparations_dissertation", null: false
  end

  create_table "stats", id: :serial, force: :cascade do |t|
    t.integer "skip_dissertation", limit: 2, default: 0, null: false
    t.integer "long_journey", limit: 2, default: 0, null: false
    t.integer "lenient_answer", limit: 2, default: 0, null: false
    t.integer "lenient_name", limit: 2, default: 1, null: false
    t.integer "avoid_negative", limit: 2, default: 0, null: false
    t.integer "focus_level", limit: 2, default: 0, null: false
    t.integer "questions_pref", limit: 2, default: 0, null: false
    t.integer "journey_id", default: 0, null: false
    t.integer "theme_id", default: 1, null: false
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.text "title", null: false
    t.integer "difficulty", null: false
    t.integer "formula", limit: 2, default: 0, null: false
    t.integer "evaluable", limit: 2, default: 1, null: false
    t.integer "stat_id", default: 1, null: false
    t.index ["title"], name: "subjects_title_key", unique: true
  end

  create_table "themes", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.text "background", null: false
    t.text "color", null: false
    t.text "element", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "username", null: false
    t.text "password", null: false
    t.integer "profile_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions", name: "question"
  add_foreign_key "answers", "quizzes", name: "quiz"
  add_foreign_key "chairs", "journeys", name: "journey"
  add_foreign_key "chairs", "subjects", name: "subject"
  add_foreign_key "choices", "questions", name: "question"
  add_foreign_key "journeys", "soundtracks", name: "journeys_soundtrack_id_fkey"
  add_foreign_key "stats", "journeys", name: "journey"
  add_foreign_key "stats", "themes", name: "theme"
end
