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

ActiveRecord::Schema[7.0].define(version: 20_220_114_181_559) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'action_text_rich_texts', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'body'
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[record_type record_id name], name: 'index_action_text_rich_texts_uniqueness', unique: true
  end

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', precision: nil, null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', precision: nil, null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'admins', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at', precision: nil
    t.datetime 'remember_created_at', precision: nil
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at', precision: nil
    t.datetime 'last_sign_in_at', precision: nil
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at', precision: nil
    t.datetime 'confirmation_sent_at', precision: nil
    t.string 'unconfirmed_email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_admins_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_admins_on_reset_password_token', unique: true
  end

  create_table 'comments', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'commentable_type', null: false
    t.bigint 'commentable_id', null: false
    t.integer 'parent_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[commentable_type commentable_id], name: 'index_comments_on_commentable'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'games', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.string 'author'
    t.bigint 'user_id'
    t.bigint 'admin_id'
    t.text 'bbg_link'
    t.text 'image'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['admin_id'], name: 'index_games_on_admin_id'
    t.index ['user_id'], name: 'index_games_on_user_id'
  end

  create_table 'match_invitations', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'match_id', null: false
    t.datetime 'created_at', precision: nil, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    t.datetime 'updated_at', precision: nil, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    t.index ['match_id'], name: 'index_match_invitations_on_match_id'
    t.index %w[user_id match_id], name: 'index_match_invitations_on_user_id_and_match_id', unique: true
    t.index ['user_id'], name: 'index_match_invitations_on_user_id'
  end

  create_table 'match_participants', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'match_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['match_id'], name: 'index_match_participants_on_match_id'
    t.index %w[user_id match_id], name: 'index_match_participants_on_user_id_and_match_id', unique: true
    t.index ['user_id'], name: 'index_match_participants_on_user_id'
  end

  create_table 'matches', force: :cascade do |t|
    t.text 'title'
    t.text 'description'
    t.bigint 'user_id', null: false
    t.bigint 'game_id', null: false
    t.text 'location'
    t.integer 'number_of_players'
    t.datetime 'start_at', precision: nil
    t.datetime 'end_at', precision: nil
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'invited_users', default: [], array: true
    t.boolean 'public'
    t.index ['game_id'], name: 'index_matches_on_game_id'
    t.index ['user_id'], name: 'index_matches_on_user_id'
  end

  create_table 'notifications', force: :cascade do |t|
    t.string 'recipient_type', null: false
    t.bigint 'recipient_id', null: false
    t.string 'type', null: false
    t.jsonb 'params'
    t.datetime 'read_at', precision: nil
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['read_at'], name: 'index_notifications_on_read_at'
    t.index %w[recipient_type recipient_id], name: 'index_notifications_on_recipient'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at', precision: nil
    t.datetime 'remember_created_at', precision: nil
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at', precision: nil
    t.datetime 'last_sign_in_at', precision: nil
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at', precision: nil
    t.datetime 'confirmation_sent_at', precision: nil
    t.string 'unconfirmed_email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'username'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['username'], name: 'index_users_on_username', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'games', 'admins'
  add_foreign_key 'games', 'users'
  add_foreign_key 'match_invitations', 'matches'
  add_foreign_key 'match_invitations', 'users'
  add_foreign_key 'match_participants', 'matches'
  add_foreign_key 'match_participants', 'users'
  add_foreign_key 'matches', 'games'
  add_foreign_key 'matches', 'users'
end
