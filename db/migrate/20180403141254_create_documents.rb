class CreateDocuments < ActiveRecord::Migration
  def change
    create_table "documents", force: :cascade do |t|
      t.integer  "assetable_id"
      t.string   "assetable_type"
      t.string   "document_file_name"
      t.string   "document_content_type"
      t.integer  "document_file_size"
      t.datetime "document_updated_at"
      t.string   "token"
      t.string   "document_detail"
      t.boolean  "reprocessed",        default: false
      t.datetime "created_at",         null: false
      t.datetime "updated_at",         null: false
    end
  end
end



