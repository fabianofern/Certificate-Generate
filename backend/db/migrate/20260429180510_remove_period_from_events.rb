class RemovePeriodFromEvents < ActiveRecord::Migration[8.1]
  def change
    remove_column :events, :period, :string
  end
end
