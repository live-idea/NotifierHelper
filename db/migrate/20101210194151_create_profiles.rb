class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.text :signature

      t.timestamps
    end
    
    User.all.each {|u| u.profile = Profile.create}
  end

  def self.down
    drop_table :profiles
  end
end
