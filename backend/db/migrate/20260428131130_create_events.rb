class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.integer :workload
      t.string :period
      t.string :location
      t.string :instructor_name
      t.string :instructor_email
      t.string :template_name

      t.timestamps
    end
  end
end
