class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :status

      t.string :file_name
      t.string :file_path
      t.string :destination
      t.string :tags
      t.text :cart
      t.integer :delete_file
      t.string :xport_options

      t.integer :priority

      t.timestamps
    end
  end

end
