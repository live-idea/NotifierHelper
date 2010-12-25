class CreateReceipients < ActiveRecord::Migration
  def self.up
    create_table :receipients do |t|
      t.integer :notification_id
      t.integer :contact_id
      t.string :status
    end
  end

  def self.down
    drop_table :receipients
  end
end
