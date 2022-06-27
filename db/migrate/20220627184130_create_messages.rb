class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :sender
      t.integer :message_no
      t.references :chat, foreign_key: true, null: false, dependent: :destroy

      t.timestamps
    end
  end
end
