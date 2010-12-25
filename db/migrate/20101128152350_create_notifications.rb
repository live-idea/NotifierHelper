class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :event_id      
      t.string :subject
      t.text :body
      t.date :date
      t.string :status
    end
  end

  def self.down
    drop_table :notifications
  end
end
