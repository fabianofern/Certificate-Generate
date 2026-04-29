class AddDatesToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
  end
end
