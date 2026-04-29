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

ActiveRecord::Schema[8.1].define(version: 2026_04_29_180510) do
  create_table "certificates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "download_token"
    t.integer "event_id", null: false
    t.integer "participant_id", null: false
    t.string "pdf_file"
    t.text "qr_code_data"
    t.datetime "sent_at"
    t.string "sent_status"
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["download_token"], name: "index_certificates_on_download_token"
    t.index ["event_id"], name: "index_certificates_on_event_id"
    t.index ["participant_id"], name: "index_certificates_on_participant_id"
    t.index ["uuid"], name: "index_certificates_on_uuid", unique: true
  end

  create_table "email_logs", force: :cascade do |t|
    t.integer "certificate_id", null: false
    t.datetime "created_at", null: false
    t.text "error_message"
    t.string "recipient"
    t.datetime "sent_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["certificate_id"], name: "index_email_logs_on_certificate_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.string "instructor_email"
    t.string "instructor_name"
    t.string "location"
    t.date "start_date"
    t.string "template_name"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "workload"
  end

  create_table "participants", force: :cascade do |t|
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "certificates", "events"
  add_foreign_key "certificates", "participants"
  add_foreign_key "email_logs", "certificates"
end
