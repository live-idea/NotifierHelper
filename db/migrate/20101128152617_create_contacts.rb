class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :user_id
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phonenumber
      t.string :fb_id
      t.string :comment
      t.boolean :send_email
      t.boolean :send_sms
      t.boolean :only_free_sms
    end
    
    create_table :contacts_groups, :id => false do |t|
      t.integer :contact_id
      t.integer :group_id
    end
  end

  def self.down
    drop_table :contacts
  end
end
