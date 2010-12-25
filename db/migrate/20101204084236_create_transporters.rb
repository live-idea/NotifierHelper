class CreateTransporters < ActiveRecord::Migration
  def self.up
    create_table :transporters do |t|
      t.integer :user_id
      t.string :login
      t.string :password
      t.string :smtp_server
      t.string :smtp_port
      t.integer :count_per_day
      t.integer :count_left
      t.datetime :need_reset_date
    end
  end

  def self.down
    drop_table :transporters
  end
end
