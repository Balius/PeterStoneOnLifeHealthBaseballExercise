class CreateBatDetails < ActiveRecord::Migration
  def change
    create_table :bat_details do |t|
      t.string :playerID
      t.integer :yearID
      t.string :league
      t.string :teamID
      t.integer :games
      t.integer :bats
      t.integer :runs
      t.integer :hits
      t.integer :doubles
      t.integer :triples
      t.integer :homers
      t.integer :rbi
      t.integer :sb
      t.integer :cs
      t.timestamps
    end
  end
end
