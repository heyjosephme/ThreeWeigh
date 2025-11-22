class WeightHeatmapComponent < ViewComponent::Base
  def initialize(user:, days: 365)
    @user = user
    @days = days
    @heatmap_data = user.weight_logging_heatmap_data(days)
  end

  def weeks
    # Group days into weeks (7 days per column, like GitHub)
    @heatmap_data.each_slice(7).to_a
  end

  def intensity_class(day)
    # Return CSS class based on logging status
    day[:logged] ? 'bg-green-500' : 'bg-gray-200'
  end

  def month_labels
    # Generate month labels for the heatmap
    months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

    current_month = Date.current.month
    start_month = (@days.days.ago.to_date).month

    # Calculate which months to show
    labels = []
    12.times do |i|
      month_index = (start_month - 1 + i) % 12
      labels << months[month_index]
    end

    labels
  end

  def day_of_week_labels
    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  end

  def tooltip_text(day)
    date = Date.parse(day[:date])
    formatted_date = date.strftime("%b %d, %Y")

    if day[:logged]
      "#{formatted_date}: Logged ✅"
    else
      "#{formatted_date}: Not logged"
    end
  end
end
