class MasterTableFile < ActiveRecord::Migration
  def self.up
    create_table :master_table_lists do |t|
      t.integer :counter , :force=>0
      t.string :counter_string

      t.timestamps
    end
  end
end
