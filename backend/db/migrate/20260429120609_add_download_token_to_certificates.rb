class AddDownloadTokenToCertificates < ActiveRecord::Migration[8.1]
  def change
    add_column :certificates, :download_token, :string
    add_index :certificates, :download_token
  end
end
