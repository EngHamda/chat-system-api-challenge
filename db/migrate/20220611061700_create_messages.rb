class CreateMessages < ActiveRecord::Migration[5.2]
  def up
    create_table :messages do |t|
      t.references :chat, foreign_key: true
      t.integer :message_number, null: false#, default: 1 is messages_count++
      t.text :body, null: false

      t.timestamps
    end
    add_index :messages, [:chat_id, :message_number], unique: true
  end
  def down
    drop_table :messages
  end
end
