class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_time_zone
  before_action :set_current_fast, if: :user_signed_in?

  # Redirect logged-in users to dashboard instead of landing page
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # Redirect already signed in users to dashboard without notification
  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    return unless authenticated?(resource_name)

    redirect_to dashboard_path
  end

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

  def set_current_fast
    @current_fast = current_user.current_fast if current_user
  end
end
