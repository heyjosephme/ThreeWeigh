# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # Rate limit login attempts by email (prevents brute force attacks)
  # Allows 5 login attempts per email address within 20 minutes
  rate_limit to: 5, within: 20.minutes, only: :create,
             by: -> { request.params.dig('user', 'email')&.downcase&.presence }

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
