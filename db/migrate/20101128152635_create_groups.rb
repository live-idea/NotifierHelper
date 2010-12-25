class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :user_id
      t.string :name
      t.string :description
    end
  end

  def self.down
    drop_table :groups
  end
end
