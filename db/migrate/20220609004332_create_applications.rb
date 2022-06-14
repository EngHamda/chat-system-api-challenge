class CreateApplications < ActiveRecord::Migration[5.2]
  def up
    create_table :applications do |t|
      t.string :name, null: false
      #Note: as token is text can't have index_unique and don't return any error msg in rails
      #t.text :token, null: false
      t.string :token, null: false, limit: 25, index: {unique: true, name: 'index_applications_on_token'}#true, unique: true
      t.integer :chats_count, null: false, default: 0

      t.timestamps
    end
  end
  def down
    drop_table :applications
  end
end
