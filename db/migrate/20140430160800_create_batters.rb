class CreateBatters < ActiveRecord::Migration
  def change
    create_table :batters do |t|
      t.string :playerID
      t.integer :birthYear, :null => true
      t.string :nameFirst	
      t.string :nameLast
      t.timestamps
    end
  end
end
