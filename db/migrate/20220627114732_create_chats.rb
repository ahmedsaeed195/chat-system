class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :chat_no, null: false
      t.references :application, foreign_key: true, null: false, dependent: :destroy
      t.integer :messages_count, default: 0

      t.timestamps
    end
  end
end
