class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_time_zone

  def set_timezone
    timezone = params[:timezone]

    if timezone.present? && ActiveSupport::TimeZone[timezone]
      session[:user_timezone] = timezone
      render json: { status: 'success', timezone: timezone }
    else
      render json: { status: 'error', message: 'Invalid timezone' }, status: :unprocessable_entity
    end
  end

  private

  def set_time_zone
    Time.zone = session[:user_timezone] || 'UTC'
  end
end
