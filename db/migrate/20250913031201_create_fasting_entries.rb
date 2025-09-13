class CreateFastingEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :fasting_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.integer :planned_duration, comment: "Planned duration in minutes"
      t.string :status, default: "active"
      t.text :notes

      t.timestamps
    end
    
    add_index :fasting_entries, [:user_id, :start_time]
    add_index :fasting_entries, :status
  end
end
