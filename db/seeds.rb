# Seeds file for ThreeWeigh - Development & Testing Data
# Run with: rails db:seed

puts "🌱 Seeding database..."

# Clean up existing data (for idempotency)
puts "Cleaning existing data..."
WeightEntry.destroy_all
FastingEntry.destroy_all
User.destroy_all

# Create test user
puts "Creating test user..."
user = User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password",
  unit_system: "metric",
  height: 175,  # cm
  goal_weight: 70,  # kg
  age: 30,
  gender: "male",
  activity_level: "moderate"
)

puts "✅ Created user: #{user.email}"

# Create weight entries (90 days of data with realistic patterns)
puts "Creating weight entries..."
start_weight = 85.0  # kg
target_weight = 70.0
days_to_seed = 90

weight_entries_created = 0

days_to_seed.times do |i|
  date = i.days.ago.to_date

  # Simulate realistic weight loss pattern
  # - Gradual decline with plateaus
  # - Random fluctuations (water weight, etc.)
  # - Not every day logged (realistic user behavior)

  # Skip some days randomly (80% logging rate)
  next if rand > 0.8

  # Calculate weight with gradual loss + fluctuations
  days_elapsed = days_to_seed - i
  progress = days_elapsed.to_f / days_to_seed

  # Gradual weight loss (0.5 kg per week average)
  expected_loss = (days_elapsed / 7.0) * 0.5
  current_weight = start_weight - expected_loss

  # Add realistic fluctuations (±0.5kg)
  fluctuation = (rand * 1.0) - 0.5

  # Add weekly plateaus (more realistic)
  if (days_elapsed % 7) < 2
    fluctuation += 0.3  # Slight increase on weekends
  end

  final_weight = (current_weight + fluctuation).round(1)

  # Create weight entry
  WeightEntry.create!(
    user: user,
    weight: final_weight,
    date: date,
    notes: ["Morning weigh-in", "After workout", "Feeling good!", nil, nil].sample
  )

  weight_entries_created += 1
end

puts "✅ Created #{weight_entries_created} weight entries (last 90 days with ~80% consistency)"

# Create fasting entries (mix of completed, active, and broken)
puts "Creating fasting entries..."
fasting_entries_created = 0

# Recent completed fasts
[24, 20, 18, 16, 16, 18, 16].each_with_index do |duration_hours, i|
  start_time = (i + 2).days.ago + rand(0..8).hours
  end_time = start_time + duration_hours.hours + rand(-30..30).minutes

  FastingEntry.create!(
    user: user,
    start_time: start_time,
    end_time: end_time,
    planned_duration: duration_hours * 60,  # minutes
    status: "completed",
    notes: ["Felt great!", "Easier than expected", "Intermittent fasting 16:8", nil].sample
  )

  fasting_entries_created += 1
end

# Some broken fasts (realistic!)
[18, 16, 24].each_with_index do |duration_hours, i|
  start_time = (i + 10).days.ago + rand(0..8).hours
  end_time = start_time + (duration_hours * 0.6).hours  # Broke early

  FastingEntry.create!(
    user: user,
    start_time: start_time,
    end_time: end_time,
    planned_duration: duration_hours * 60,
    status: "broken",
    notes: ["Social event came up", "Too hungry", "Will try again"].sample
  )

  fasting_entries_created += 1
end

# One active fast (currently ongoing)
FastingEntry.create!(
  user: user,
  start_time: 8.hours.ago,
  planned_duration: 16 * 60,  # 16 hour fast
  status: "active",
  notes: "16:8 intermittent fasting"
)

fasting_entries_created += 1

puts "✅ Created #{fasting_entries_created} fasting entries"

# Summary
puts "\n" + "="*50
puts "🎉 Seeding complete!"
puts "="*50
puts "📊 Summary:"
puts "  - User: #{user.email}"
puts "  - Password: password"
puts "  - Weight Entries: #{user.weight_entries.count}"
puts "  - Weight Range: #{user.weight_entries.minimum(:weight)}kg - #{user.weight_entries.maximum(:weight)}kg"
puts "  - Current Streak: #{user.weight_logging_streak} days"
puts "  - Longest Streak: #{user.longest_weight_logging_streak} days"
puts "  - Fasting Entries: #{user.fasting_entries.count}"
puts "  - Active Fast: #{user.current_fast.present? ? 'Yes' : 'No'}"
puts "="*50
puts "\n💡 Login at http://localhost:3000 with:"
puts "   Email: test@example.com"
puts "   Password: password"
puts "\n🚀 Have fun testing!"
