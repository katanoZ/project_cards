# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_25_071508) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.string "name", null: false
    t.date "due_date"
    t.bigint "assignee_id", null: false
    t.bigint "project_id", null: false
    t.bigint "column_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["assignee_id"], name: "index_cards_on_assignee_id"
    t.index ["column_id"], name: "index_cards_on_column_id"
    t.index ["project_id", "name"], name: "index_cards_on_project_id_and_name", unique: true
    t.index ["project_id"], name: "index_cards_on_project_id"
  end

  create_table "columns", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.index ["project_id", "name"], name: "index_columns_on_project_id_and_name", unique: true
    t.index ["project_id"], name: "index_columns_on_project_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_invitations_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_invitations_on_project_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_logs_on_project_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_participations_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_participations_on_project_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.text "summary"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["owner_id"], name: "index_projects_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cards", "columns"
  add_foreign_key "cards", "projects"
  add_foreign_key "cards", "users", column: "assignee_id"
  add_foreign_key "columns", "projects"
  add_foreign_key "invitations", "projects"
  add_foreign_key "invitations", "users"
  add_foreign_key "logs", "projects"
  add_foreign_key "participations", "projects"
  add_foreign_key "participations", "users"
  add_foreign_key "projects", "users", column: "owner_id"
end
