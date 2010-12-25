class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :user_id
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
