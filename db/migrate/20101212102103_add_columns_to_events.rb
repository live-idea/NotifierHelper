class AddColumnsToEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :date
    add_column :events, :start_date, :datetime
    add_column :events, :end_date, :datetime
  end

  def self.down
    add_column :events, :date, :date
    remove_column :events, :start_date
    remove_column :events, :end_date
  end
end
