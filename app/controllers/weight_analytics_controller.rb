class WeightAnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    begin
      @analytics_service = WeightAnalyticsService.new(current_user)
      @analytics_data = @analytics_service.calculate_analytics
    rescue NameError
      # If service class not found, require it explicitly
      require_relative "../services/weight_analytics_service"
      @analytics_service = WeightAnalyticsService.new(current_user)
      @analytics_data = @analytics_service.calculate_analytics
    end
  end
end
