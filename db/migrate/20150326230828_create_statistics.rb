class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :email
      t.integer :action_correct
      t.integer :action_total
      t.integer :adventure_correct
      t.integer :adventure_total
      t.integer :arcade_correct
      t.integer :arcade_total
      t.integer :fps_correct
      t.integer :fps_total
      t.integer :racing_correct
      t.integer :racing_total
      t.integer :role_playing_correct
      t.integer :role_playing_total

      t.timestamps null: false
    end
  end
end
