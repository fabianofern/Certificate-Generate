class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email
      t.string :cpf

      t.timestamps
    end
  end
end
