class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :message_no
      t.string :sender, default: 'Unknown'
      t.string :content, default: ''
      t.references :chat, foreign_key: true, null: false, dependent: :destroy

      t.timestamps
    end
  end
end
