class AddActiveToParticipants < ActiveRecord::Migration[8.1]
  def change
    add_column :participants, :active, :boolean, default: true
  end
end
