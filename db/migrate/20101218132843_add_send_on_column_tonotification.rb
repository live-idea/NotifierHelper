class AddSendOnColumnTonotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :send_on, :datetime    
  end

  def self.down
    remove_column :notifications, :send_on
  end
end
