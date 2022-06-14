class CreateChats < ActiveRecord::Migration[5.2]
  def up
    create_table :chats do |t|
      t.references :application, foreign_key: true
      #t.index [:application_id, :chat_number], unique: true
      t.integer :chat_number, null: false#, default: 1 is chats_count++
      t.integer :messages_count, null: false, default: 0

      t.timestamps
    end
    add_index :chats, [:application_id, :chat_number], unique: true
  end
  def down
    drop_table :chats
  end
end
