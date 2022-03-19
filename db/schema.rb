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

ActiveRecord::Schema[7.0].define(version: 2022_03_18_143645) do
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
    t.text "attempt", null: false
    t.integer "questionid", null: false
    t.decimal "grade", default: "0.0", null: false
    t.text "parameters"
  end

  create_table "journeys", id: false, force: :cascade do |t|
    t.text "subject", default: "Nenhuma"
    t.integer "id"
    t.float "grade_1"
    t.float "grade_2"
    t.float "grade_reposition"
    t.float "grade_dissertation"
    t.float "exam"
    t.float "exam_reposition"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.text "subject", null: false
    t.text "questiontype", default: "open", null: false
    t.text "question", null: false
    t.text "choices"
    t.text "answer", null: false
    t.integer "level"
    t.text "tags", default: "[]", null: false
    t.integer "frequency", default: 0, null: false
    t.text "parameters", default: "[]", null: false
    t.index ["question"], name: "quiz_question_key", unique: true
  end

  create_table "quizzes", id: false, force: :cascade do |t|
    t.text "name", null: false
    t.text "surname", null: false
    t.text "subject", null: false
    t.integer "id", default: -> { "nextval('seq_id'::regclass)" }, null: false
    t.text "journey"
    t.text "answerarray", null: false
    t.integer "timestarted", null: false
    t.integer "timeended", null: false
    t.integer "format"
    t.integer "level"
  end

  create_table "statistics", id: false, force: :cascade do |t|
    t.integer "totalquestions", null: false
    t.integer "totalquizzes", null: false
    t.integer "lastquizid", null: false
    t.integer "totaljourneys", null: false
    t.integer "activejourneyid", null: false
    t.integer "activejourneylevel", default: 0, null: false
    t.integer "totalusers", null: false
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.text "title"
    t.integer "difficulty"
    t.integer "preferredformat", default: 0
    t.index ["title"], name: "subjects_title_key", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
