class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :task
      t.belongs_to :notifier
      t.time :sent_at
      t.timestamps
    end
  end

end
