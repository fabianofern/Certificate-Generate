class CreateCertificates < ActiveRecord::Migration[8.1]
  def change
    create_table :certificates do |t|
      t.references :event, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: true
      t.string :uuid
      t.text :qr_code_data
      t.string :pdf_file
      t.datetime :sent_at
      t.string :sent_status

      t.timestamps
    end
    add_index :certificates, :uuid, unique: true
  end
end
