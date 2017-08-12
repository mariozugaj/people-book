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

ActiveRecord::Schema.define(version: 20170812172529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.bigint "author_id"
    t.text "text"
    t.integer "likes_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["commentable_type", "commentable_id", "author_id"], name: "by_commentable_and_author"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["sender_id", "receiver_id"], name: "index_conversations_on_sender_id_and_receiver_id", unique: true
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "description"
    t.string "image"
    t.integer "likes_count"
    t.integer "comments_count"
    t.bigint "photo_album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["photo_album_id"], name: "index_images_on_photo_album_id"
  end

  create_table "likes", force: :cascade do |t|
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["likeable_type", "likeable_id", "user_id"], name: "by_likeable_and_user"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id"
    t.bigint "user_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "actor_id"
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.integer "read_at"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "photo_albums", force: :cascade do |t|
    t.bigint "author_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["author_id", "name"], name: "index_photo_albums_on_author_id_and_name"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "birthday"
    t.string "education"
    t.string "hometown"
    t.string "profession"
    t.string "company"
    t.string "relationship_status"
    t.string "about"
    t.string "phone_number"
    t.string "avatar"
    t.string "cover_photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "status_updates", force: :cascade do |t|
    t.bigint "author_id"
    t.text "text"
    t.integer "likes_count"
    t.integer "comments_count"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["author_id"], name: "index_status_updates_on_author_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "profiles", "users"
end
