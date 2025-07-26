class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :weight_entries, dependent: :destroy

  def latest_weight
    weight_entries.recent.first
  end

  def weight_trend(days = 30)
    weight_entries.for_period(days.days.ago.to_date, Date.current)
  end
end
