class CreateEmailLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :email_logs do |t|
      t.references :certificate, null: false, foreign_key: true
      t.string :recipient
      t.string :status
      t.text :error_message
      t.datetime :sent_at

      t.timestamps
    end
  end
end
