class ContactsNewColumns < ActiveRecord::Migration
  def self.up
    add_column :contacts, :vk_id, :string
  end

  def self.down
    remove_column :contacts, :vk_id
  end
end
