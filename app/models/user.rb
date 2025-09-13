class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :weight_entries, dependent: :destroy
  has_many :fasting_entries, dependent: :destroy

  def latest_weight
    weight_entries.recent.first
  end

  def weight_trend(days = 30)
    weight_entries.for_period(days.days.ago.to_date, Date.current)
  end

  def current_fast
    fasting_entries.active.order(start_time: :desc).first
  end

  def fasting_streak
    # Count consecutive days with completed fasts
    recent_fasts = fasting_entries.completed.recent.limit(30)
    streak = 0
    current_date = Date.current
    
    recent_fasts.each do |fast|
      if fast.start_time.to_date == current_date
        streak += 1
        current_date -= 1.day
      else
        break
      end
    end
    
    streak
  end
end
