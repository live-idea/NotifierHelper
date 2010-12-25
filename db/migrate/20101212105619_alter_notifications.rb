class AlterNotifications < ActiveRecord::Migration
  def self.up
    remove_column :notifications, :date
    add_column :notifications, :start_date, :datetime
    add_column :notifications, :end_date, :datetime
    add_column :notifications, :sms_body, :text
    add_column :notifications, :frequency, :string
  end

  def self.down
    add_column :notifications, :date, :date
    remove_column :notifications, :start_date
    remove_column :notifications, :end_date
    remove_column :notifications, :sms_body
    remove_column :notifications, :frequency
  end
end
