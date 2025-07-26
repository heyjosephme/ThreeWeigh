class WeightEntry < ApplicationRecord
  belongs_to :user

  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date, message: "One entry per day" }

  scope :recent, -> { order(date: :desc) }
  scope :for_period, ->(start_date, end_date) { where(date: start_date..end_date) }
end
