class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :height, :decimal, precision: 5, scale: 1, comment: "Height in cm"
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :goal_weight, :decimal, precision: 5, scale: 1, comment: "Goal weight in kg"
    add_column :users, :unit_system, :string, default: "metric", null: false, comment: "metric or imperial"
    add_column :users, :activity_level, :string, comment: "sedentary, light, moderate, active, very_active"
  end
end
