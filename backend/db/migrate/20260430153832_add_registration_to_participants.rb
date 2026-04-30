class AddRegistrationToParticipants < ActiveRecord::Migration[8.1]
  def change
    add_column :participants, :registration, :string
  end
end
