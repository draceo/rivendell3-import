class CreateNotifiers < ActiveRecord::Migration[6.0]
  def change
    create_table :notifiers do |t|
      t.string :type
      t.string :key
      t.text :parameters
      t.timestamps
    end
  end

end
