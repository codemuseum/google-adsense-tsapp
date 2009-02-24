class CreateAdUnits < ActiveRecord::Migration
  def self.up
    create_table :ad_units do |t|
      t.string :site_uid
      t.string :nickname
      t.text :code
      t.boolean :default
    
      t.timestamps
    end
    add_index :ad_units, :site_uid
    add_index :ad_units, :nickname
    add_index :ad_units, :default
  end

  def self.down
    drop_table :ad_units
  end
end
