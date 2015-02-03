class MasterCounterTable < ActiveRecord::Migration
  def self.up
    create_table :master_counter_lists do |t|
      t.integer :counter , :force=>0
      t.string :counter_string

      t.timestamps
    end
  end

  def self.down
    drop_table :master_counter_lists
  end
end
